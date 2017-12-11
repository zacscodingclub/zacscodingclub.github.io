---
layout: page
title: Projects
permalink: /projects/
---

<div class="posts">
{% for project in site.projects %}
  <article class="post">
    <h2><a href="{{ site.baseurl }}{{ project.url }}">{{ project.title }}</a></h2>
  </article>
{% endfor %}
</div>
