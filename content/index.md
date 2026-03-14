:::layout

```{=html}
<div style="grid-column: 1 / -1;" class="hero panel">
  <div class="description">
    <div class="name">
      <h1 class="title">Duong Vu Cong Tuan</h1>
    </div>
    <div class="salute">
    <span>
      Hello! I'm Duong Vu Cong Tuan, a software developer. I am currently a senior at PTIT, Hanoi, Vietnam and a software developer intern. Welcome to my blog about programming, software development, my life, my point of view and everything in between.
    </span>
    </div>
  </div>
</div>
```


:::{.panel id="posts"}
```{=html}
<h2 class="section-title">Recent Posts</h2>
```

{{ post-list 7 }}

[View all...](/posts)
:::



```{=html}
<!-- Projects panel -->
<section id="projects" class="panel" style="grid-column: 1 / -1;">
  <h2 class="section-title">Projects</h2>

  <ol class="project-list" aria-label="Projects">
    <li>
      <div class="title">
        <span class="date">January 2026 - January 2026</span>
        <a href="https://github.com/vucongtuanduong/codecrafters-shell-go1">
          Shell implementation from scratch in Go
        </a>
      </div>
      <div class="meta">
        <span class="authors">Author: Duong Vu Cong Tuan</span>
        <p class="description">
          A shell written from scratch in Go, supporting builtin commands (exit, echo, type, pwd, cd), executing external programs, navigation, quoting, redirection, autocompletion, pipelines and history with the help of Codecrafter platform
        </p>
        <div class="meta">
          <a class="skill">Go</a>
          <a class="skill">Bash</a>
        </div>
      </div>
    </li>


    <li>
      <div class="title">
        <span class="date">April 2025 - June 2025</span>
        <a href="https://github.com/Duong-Vu-Personal-Projects/load-testing-system">
          Load testing system
        </a>
      </div>
      <div class="meta">
        <span class="authors">Author: Duong Vu Cong Tuan</span>
        <p class="description">
          A fully dockerized system built with ReactJS and Spring Boot which allows user to create JMeter-like load test scenario in web, schedule, run, and view the visualization result of the test
        </p>
        <div class="meta">
          <a class="skill">Java</a>
          <a class="skill">Prometheus</a>
          <a class="skill">Grafana</a>
        </div>
      </div>
    </li>
  </ol>
</section>
```
:::
