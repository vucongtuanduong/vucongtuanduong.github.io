local Date = require "filters.lib.date"
local fs   = require "filters.lib.fs"
local core = require "filters.lib.core"

local function getfilename(path)
  local fname = pandoc.path.split_extension(pandoc.path.split_extension(pandoc.path.filename(path)))
  return fname
end

local function extract_strings(xs)
  if xs == nil then return {} end
  if pandoc.utils.type(xs) ~= "List" then
    xs = pandoc.List({xs})
  end
  return xs:map(function(s)
    return pandoc.utils.stringify(s):gsub("%s+", "-"):lower()
  end)
end

function Meta(m)
  local dirs = {"posts", "school"}
  local all_items = {}

  for _, dir in ipairs(dirs) do
    local postdir = "content/" .. dir
    local posts   = pandoc.system.list_directory(postdir)

    for _, post in ipairs(posts) do
      local path = pandoc.path.join{postdir, post}
      local meta = fs.read_metadata(path)
      
      table.insert(all_items, {
        title       = pandoc.utils.stringify(meta.title or ""),
        href        = string.format("/%s/%s/", dir, getfilename(post)),
        date        = Date(meta.date):string("."),
        themes      = extract_strings(meta.theme),
        keywords    = extract_strings(meta.keywords),
        description = pandoc.utils.stringify(meta.description or ""),
        type        = dir
      })
    end
  end

  -- Sort by date descending
  table.sort(all_items, function(a, b) return a.date > b.date end)

  -- We print the JSON to stdout and capture it in the Makefile
  -- However, pandoc filters usually return a modified Meta.
  -- To just get the data, we might need a slightly different approach or use a separate script.
  -- But we can also just create a dummy doc and use a template.
  
  -- Alternative: Return the data in a Meta field and use a custom template to output JSON.
  m.search_index = all_items
  return m
end
