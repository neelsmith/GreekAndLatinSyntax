# GreekSyntax

This repository presents a straightforward model of ancient Greek syntax, hosted on github pages at [https://neelsmith.github.io/GreekSyntax/](https://neelsmith.github.io/GreekSyntax/).

The model is computationally implemented in the Julia language by the `GreekSyntax.jl` package.  See [documentation for the Julia package](https://neelsmith.github.io/GreekSyntax.jl/stable/).


This repository includes Pluto notebooks for the reading and study of ancient Greek texts using the `GreekSyntax.jl` package.




## Reading syntactically annotated texts

In the `pluto` directory, you can find the following notebooks:

- `readsentences.jl`: read texts with options to visualize syntax per sentence
- `readsubordination.jl`:  read texts with options to explore sentences by level of syntactic subordination

## Annotating citable texts.

You can use `ctssyntaxer.jl` kn the `pluto` directory to annotate the syntax of a citable Greek text.

The notebook relies on an unpublished package (the invaluable [`PlutoGrid` package](https://github.com/lungben/PlutoGrid.jl) by Benjamin Lungwitz). For that reason, it comes with accompanying `Project.toml` and `Manifest.toml` files in the `pluto` directory.  If you start a Pluto server and open `pluto/ctssyntaxer.jl`, it should be able to build all the resources it needs (eventually: the first build especially will be slow).

Note that this limitation does not apply to notebooks for reading annoated texts.


## In development

- `syntacticpublisher.jl`: generate static webpages for reading syntactically annotated texts