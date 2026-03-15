document.addEventListener('DOMContentLoaded', async () => {
    const searchInput = document.getElementById('search-input');
    const resultsContainer = document.getElementById('search-results');
    const tagFilters = document.getElementById('tag-filters');
    
    let searchIndex = [];
    let selectedTags = new Set();

    // Fetch the search index
    try {
        const response = await fetch('/search.json');
        searchIndex = await response.json();
        
        // Initialize tag clouds
        const allTags = new Set();
        searchIndex.forEach(item => {
            item.themes.forEach(t => allTags.add(t));
            item.keywords.forEach(k => allTags.add(k));
        });
        
        renderTags(Array.from(allTags).sort());
        renderResults(searchIndex);
    } catch (e) {
        console.error("Failed to load search index", e);
        resultsContainer.innerHTML = "<p>Failed to load search index. Please try again later.</p>";
    }

    function renderTags(tags) {
        tagFilters.innerHTML = tags.map(tag => `
            <button class="tag-chip" data-tag="${tag}">${tag}</button>
        `).join('');

        tagFilters.querySelectorAll('.tag-chip').forEach(btn => {
            btn.addEventListener('click', () => {
                const tag = btn.dataset.tag;
                if (selectedTags.has(tag)) {
                    selectedTags.delete(tag);
                    btn.classList.remove('active');
                } else {
                    selectedTags.add(tag);
                    btn.classList.add('active');
                }
                filterIndex();
            });
        });
    }

    function filterIndex() {
        const query = searchInput.value.toLowerCase();
        
        const filtered = searchIndex.filter(item => {
            const matchesQuery = item.title.toLowerCase().includes(query) || 
                                 item.description.toLowerCase().includes(query) ||
                                 item.keywords.some(k => k.toLowerCase().includes(query)) ||
                                 item.themes.some(t => t.toLowerCase().includes(query));
            
            const matchesTags = selectedTags.size === 0 || 
                                Array.from(selectedTags).every(tag => 
                                    item.themes.includes(tag) || item.keywords.includes(tag)
                                );
            
            return matchesQuery && matchesTags;
        });

        renderResults(filtered);
    }

    function renderResults(results) {
        if (results.length === 0) {
            resultsContainer.innerHTML = "<p>No results found.</p>";
            return;
        }

        resultsContainer.innerHTML = `
            <ol class="post-list">
                ${results.map(item => `
                    <li>
                        <span class="theme-marker ${item.themes[0] || ''}" aria-hidden="true"></span>
                        <a href="${item.href}">
                            <span class="title">${item.title}</span>
                            <time class="date" datetime="${item.date}">${item.date}</time>
                        </a>
                    </li>
                `).join('')}
            </ol>
        `;
    }

    searchInput.addEventListener('input', filterIndex);
});
