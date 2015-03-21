Usage
=====

*TODO*

* src is the string representation of the graph written in Dot language.
* format is the graph output format in terms of dot -T. Since the result of the
function is returned as a string, the only sane formats are "dot" and "svg".
Typically, one would use "svg" to display the rendered result.
* engine is the Graphviz layout engine to use. Can be any from "dot", "neato",
"circo", "twopi" or others. Usually, one is satisfied with "dot" or "neato".
* options are the array of extra command line arguments which are virtually added
to the corresponding engine invocation (thanks to GVC API's gvParseArgs()). To
get an idea what such options can be, execute "dot --help" in your system's
terminal. As an example, options=["-n"] makes neato enter "no layout" mode to
render graphs already converted to "dot" output format as-is.





Developing and Building [graphviz-emscriptened]
===============================================

*TODO*





How to work with git on a project that is a copy of an existing project
=======================================================================

A reasonable way to do this is described at
[StackOverflow](http://stackoverflow.com/questions/5661405/best-workflow-when-forking-and-renaming-a-github-project).

In our local repositories, we work with 3 remotes:
- `origin` refers to [https://github.com/Toryt/graphviz-emscriptened.git]. Our local repository's `master` branch tracks
  `origin/master`.
- `upstream` refers to the original [viz.js] project. Our local repository's `upstream-master` branch tracks
  `upstream/master`. This allows us to pull in possible changes to [viz.js] later.
- `backport` refers to [https://github.com/Toryt/viz.js.git], which is our fork of [viz.js]. Our local repository's
  `backport` branch refers to the remote `backport\backport` branch. This is where we might originate pull requests to
  [viz.js] from.

[graphviz-emscriptened] welcomes pull requests on its `master` branch.





Origin, and why the fork / copy / new project
=============================================

Origin
------

This project is based on [viz.js] by [Mike Daines](https://github.com/mdaines).

While looking for a JavaScript solution to render graphs defined in the DOT language, I found several suggestions
(notably at [StackOverflow](http://stackoverflow.com/questions/6344318/pure-javascript-graphviz-equivalent)).
After some inspection and trials, [viz.js] was the first I got working. It still seems the best attempt I found until
now (if I found something better, I wouldn't have created [graphviz-emscriptened]).

Still, [viz.js] has some major issues for our use.



Why the fork
------------

First of all, it is aimed at usage in the browser, while my first goal is usage in [node.js] or [io.js]. I found out
that [emscripten] has direct and good support for this by default. Better, the result [emscripten] offers is compatible
with a lot of use cases. What [viz.js] does in the `pre.js` and `post.js` files, is, as far as I can see, superfluous
and even counter-productive. Overriding the `print` method is a good idea, but making the function available in a
special way limits the possible usages.

*TODO: add a way here to make usage more easy.*

Second, I quickly found out that [viz.js] uses neither the last version of [emscripten], nor [graphviz], and isn't
really that active. Furthermore, the way it is set up, [emscripten] and some other necessities are included in the
project as a submodule, which might not be the best idea for a development tool, and didn't work on my Mac anyway.

I rather quickly got a first version working, but the tweaks are major, and probably a departure from some of the
outsets of the original author. I estimate the chances of getting these tweaks included back upstream minimal, so
I created a fork / copy / new project altogether.



Acknowledgements
----------------

Directly, this work is based on the effort of [Mike Daines](https://github.com/mdaines), who himself acknowledges

- [Ueyama Satoshi](https://github.com/gyuque)
- [Brenton Partridge](https://github.com/bpartridge)
- [Jimmy Bogard](https://github.com/jbogard)
- [Kyle P Davis](https://github.com/KylePDavis)
- [siefkenj](https://github.com/siefkenj)
- [Spencer Rathbun](https://github.com/srathbun)
- [Vadim Markovtsev](https://github.com/vmarkovtsev)

And of course, this result would not be possible without the contribution of everyone over the last decades to
[graphviz], and [emscripten].





Licenses
========

### [graphviz-emscriptened]

The [graphviz-emscriptened] project files, and the resulting distribution of the [graphviz-emscriptened] JavaScript
library, are released under the [Eclipse Public License v1.0 (EPL)][EPL].

This is the simplest choice, since the resulting JavaScript library is clearly a "derivative work" of [graphviz],
which is released under the [EPL], distributed as source code. Whether the patch files are a "derivative work" is
debatable. The `Makefile` and JavaScript files provided by this project are a separate work, but used to create
the "derivative work". So let's not make things more difficult than necessary ...

Note that the [EPL] requires that you disclose the source of any derivative work (which [graphviz-emscriptened]
does at [GitHub][graphviz-emscriptened]).

### [viz.js]

[viz.js] doesn't mention any license information. But since the same reasoning applies, it should refer to
the [EPL] to.

What is left over from [viz.js] in this project are

- parts of the `Makefile`,
- patches to be applied to the [graphviz] source, and
- the override of the `print` function in `pre.js`.

### [graphviz]

[graphviz] has been released under the [Eclipse Public License 1.0](http://www.graphviz.org/License.php).

Since the result of this project is a "translation" of this code, this license applies to the [graphviz-emscriptened]
build results.

### [emscripten]

[emscripten] is
[made available under two permissive open source licenses](http://kripken.github.io/emscripten-site/docs/introducing_emscripten/emscripten_license.html):
the MIT license and the University of Illinois/NCSA Open Source License.
[emscripten] itself uses portions of [node.js] source code,
[made available under the MIT license](https://raw.githubusercontent.com/joyent/node/v0.12.0/LICENSE).

Since it is a tool used to create the [graphviz] "derivative work", and it is not included in this project, this is
not relevant for our license.

Note that using software released under the [MIT License] in projects under a different license is allowed.



[graphviz-emscriptened]: https://github.com/Toryt/graphviz-emscriptened
[EPL]: LICENSE.html
[MIT License]: http://opensource.org/licenses/MIT
[graphviz]: http://www.graphviz.org
[viz.js]: https://github.com/mdaines/viz.js/
[Mike Daines]: https://github.com/mdaines
[node.js]: https://nodejs.org
[io.js]: https://iojs.org/en/index.html
[emscripten]: http://kripken.github.io/emscripten-site/
