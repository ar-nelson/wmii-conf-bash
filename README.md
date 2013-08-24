wmii-conf-bash
==============

My first attempt at a modular [wmii](https://code.google.com/p/wmii/) config, written in bash and awk. This config is buggy (notably, it has a tendency to leak the forked event listener processes used to update widgets), so I wouldn't recommend using it. This config was designed for the latest hg version of wmii, and won't work with the versions found in the package managers of most Linux distros.

I'm in the process of writing a new wmii config in node.js, and I'm writing [a series of blog posts](http://sector91.wordpress.com/2013/08/22/wmiinode-js-part-0-introduction/) about it. These old config scripts are only here because they're relevant to the blog.
