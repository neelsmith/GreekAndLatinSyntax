# GreekSyntax

Contents:

- `docs` is the source for the web site at [https://neelsmith.github.io/GreekSyntax/](https://neelsmith.github.io/GreekSyntax/)
- `pluto/ctssyntaxer.jl` is a Pluto notebook for annotating Greek syntax following the model presented on the web site.


## Using the Pluto notebook

The Pluto notebook relies on an unpublished package (the invaluable [`PlutoGrid` package](https://github.com/lungben/PlutoGrid.jl) by Benjamin Lungwitz). For that reason, it comes with accompanying `Project.toml` and `Manifest.toml` files in the `pluto` directory.  If you start a Pluto server and open `pluto/ctssyntaxer.jl`, it should be able to build all the resources it needs (eventually: the first build especially will be slow).