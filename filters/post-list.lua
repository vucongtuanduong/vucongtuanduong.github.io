local Date = require "filters.lib.date"
local fs   = require "filters.lib.fs"
local core = require "filters.lib.core"
local map, take = core.map, core.take

local fmt = string.format

local function getfilename(path)
  local fname = pandoc.path.split_extension(pandoc.path.split_extension(pandoc.path.filename(path)))
  return fname
end

--- Extracts a list of themes as strings from a pandoc List or single element.
--- @param xs pandoc.List|string A pandoc List of themes or a single theme
--- @return string[] List of theme names as strings
local function extract_strings(xs)
  if pandoc.utils.type(xs) ~= "List" then
    xs = pandoc.List({xs})
  end

  return xs:map(pandoc.utils.stringify)
end

local function theme_marker(themes)
  local classes = {"theme-marker", table.unpack(themes)}

  return table.concat(classes, " ")
end

local function makeitem(meta)
  return fmt([[
    <li>
      <span class="%s" aria-hidden="true"></span>
      <a href="%s">
        <span class="title">%s</span>
        <time class="date" datetime="%s">%s</time>
      </a>
    </li>
    ]],
    theme_marker(meta.theme),
    meta.href,
    meta.title,
    meta.date:string("-"),
    meta.date:string(".")
  )
end

local function makelist(postlist)
  return fmt([[
    <ol class="post-list">
      %s
    </ol>
    ]],
    table.concat(postlist, "\n")
  )
end

local function make_postlist(dirs, n)
  if type(dirs) == "string" then
    dirs = {dirs}
  end

  local all_metadata = {}

  for _, dir in ipairs(dirs) do
    local path = "content/" .. dir
    local posts = pandoc.system.list_directory(path)

    pandoc.log.info(fmt("Found %d posts in %s", #posts, dir))

    for _, post in ipairs(posts) do
      pandoc.log.info("Reading " .. dir .. "/" .. post)
      local meta = fs.read_metadata(pandoc.path.join{path, post})

      table.insert(all_metadata, {
        href       = fmt("/%s/%s/", dir, getfilename(post)),
        date       = Date(meta.date),
        theme      = extract_strings(meta.theme),
        title      = pandoc.utils.stringify(meta.title),
        requisites = extract_strings(meta.requisites),
      })
    end
  end

  n = math.min(n or math.huge, #all_metadata)
  pandoc.log.info(fmt("Making list with %d out of %d total items", n, #all_metadata))

  table.sort(all_metadata, function(a, b) return a.date > b.date end)

  local items = map(take(all_metadata, n), makeitem)

  return makelist(items)
end

function Block(elem)
  if elem.content then
    local text = pandoc.utils.stringify(elem.content)

    local num_posts = string.match(text, "^%s*{{%s*post%-list%s*(%d*)%s*}}%s*$")
    if num_posts then
      local postlist = make_postlist("posts", tonumber(num_posts))
      return pandoc.RawBlock("html", postlist)
    end

    local num_school = string.match(text, "^%s*{{%s*school%-list%s*(%d*)%s*}}%s*$")
    if num_school then
      local postlist = make_postlist("school", tonumber(num_school))
      return pandoc.RawBlock("html", postlist)
    end

    local num_recent = string.match(text, "^%s*{{%s*recent%-list%s*(%d*)%s*}}%s*$")
    if num_recent then
      local postlist = make_postlist({"posts", "school"}, tonumber(num_recent))
      return pandoc.RawBlock("html", postlist)
    end
  end
end
