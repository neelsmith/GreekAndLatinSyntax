### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# ╔═╡ 5470d560-85c7-11ed-21f4-c95eb6ad8076
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate(".")
	Pkg.instantiate()
	Pkg.add(url="https://github.com/neelsmith/GreekSyntax.jl")
	using GreekSyntax
	Pkg.add("Orthography")
	using Orthography
	Pkg.add("PolytonicGreek")
	using PolytonicGreek
	Pkg.add("CitableCorpus")
	using CitableCorpus
	Pkg.add("CitableText")
	using CitableText
	Pkg.add("CitableBase")
	using CitableBase
end


# ╔═╡ 8d3fe619-2b9a-4dcc-a4fa-399eecb54f9e
md"""## Analyze syntactic annotations"""

# ╔═╡ 24e4112a-421c-42a9-b95d-56a8b1d54d31
f = joinpath(pwd(), "testdata", "lysias1_selection.cex")

# ╔═╡ 8bcb50c8-9183-4133-9270-a8ff912cffa7
(sentences, verbalunits, tokens) = parsedelimited(readlines(f))

# ╔═╡ 4b4cc7d5-5c42-4366-baea-28259675b2f9
md"""
- **$(length(sentences))** sentences
- **$(length(verbalunits))** verbal units
- **$(length(tokens))** tokens
"""

# ╔═╡ Cell order:
# ╠═5470d560-85c7-11ed-21f4-c95eb6ad8076
# ╟─8d3fe619-2b9a-4dcc-a4fa-399eecb54f9e
# ╠═24e4112a-421c-42a9-b95d-56a8b1d54d31
# ╠═8bcb50c8-9183-4133-9270-a8ff912cffa7
# ╠═4b4cc7d5-5c42-4366-baea-28259675b2f9
