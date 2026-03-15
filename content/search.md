---
title: Search
css: [/css/search.css]
header-includes:
  - <script src="/js/search.js" defer></script>
---

# Search

```{=html}
<div class="search-container">
    <input type="text" id="search-input" placeholder="Search by title, keyword, or tag..." autofocus>
    
    <div id="tag-filters" class="tag-cloud">
        <!-- Tags will be rendered here -->
    </div>

    <div id="search-results">
        <p>Loading index...</p>
    </div>
</div>
```
