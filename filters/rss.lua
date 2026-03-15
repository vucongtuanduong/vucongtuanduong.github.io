local Date = require "filters.lib.date"
local fs   = require "filters.lib.fs"
local core = require "filters.lib.core"

function template_variable(k)
  return tostring(PANDOC_WRITER_OPTIONS.variables[k])
end

local function getfilename(path)
  local fname = pandoc.path.split_extension(pandoc.path.split_extension(pandoc.path.filename(path)))
  return fname
end

function canonical_url(dir, fname)
  local relative = getfilename(fname)
  local sitebase = template_variable("site-url")

  return pandoc.path.join {sitebase, dir, relative} .. "/"
end

function makeitem(dir, post)
  local meta = fs.read_metadata(post)
  local date = Date(meta.date)

  local info = {
    title           = pandoc.utils.stringify(meta.title),
    date            = date,
    ["date-rfc822"] = date:rfc822(),
    description     = pandoc.utils.stringify(meta.description),
    url             = canonical_url(dir, post),
  }

  return info
end

function Meta(m)
  local dirs = {"posts", "school"}
  local all_posts = {}

  for _, dir in ipairs(dirs) do
    local postdir = "content/" .. dir
    local posts   = pandoc.system.list_directory(postdir)

    for _, post in ipairs(posts) do
      table.insert(all_posts, makeitem(dir, pandoc.path.join{postdir, post}))
    end
  end

  m.posts = all_posts
  table.sort(m.posts, function(a, b) return a.date > b.date end)

  return m
end
