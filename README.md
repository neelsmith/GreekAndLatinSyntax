# GreekAndLatinSyntax

This repository presents a straightforward model of ancient Greek and Latin syntax, hosted on github pages at [https://neelsmith.github.io/GreekAndLatinSyntax/](https://neelsmith.github.io/GreekAndLatinSyntax/).

The model is computationally implemented in the Julia language by the `GreekSyntax` and `LatinSyntax` package.s.   (See documentation for the Julia package:  [GreekSyntax](https://neelsmith.github.io/GreekSyntax.jl/stable/), [LatinSyntax](https://neelsmith.github.io/LatinSyntax.jl/stable/)).


This repository includes Pluto notebooks for the reading and study of ancient Greek texts using these packages.


## Reading syntactically annotated texts

In the `pluto` directory, you can find the following notebooks:

- `readsentences.jl`: read texts with options to visualize syntax per sentence
- `readsubordination.jl`:  read texts with options to explore sentences by level of syntactic subordination

## Annotating citable texts.

You can use `ctssyntaxer.jl` kn the `pluto` directory to annotate the syntax of a citable Greek text.

The notebook relies on an unpublished package (the invaluable [`PlutoGrid` package](https://github.com/lungben/PlutoGrid.jl) by Benjamin Lungwitz). For that reason, it comes with accompanying `Project.toml` and `Manifest.toml` files in the `pluto` directory.  If you start a Pluto server and open `pluto/ctssyntaxer.jl`, it should be able to build all the resources it needs (eventually: the first build especially will be slow).

Note that this limitation does not apply to notebooks for reading annoated texts. They Pluto's internal package manager, and do not need external `*.toml` files.

