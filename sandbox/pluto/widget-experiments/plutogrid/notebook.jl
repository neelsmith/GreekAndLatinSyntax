### A Pluto.jl notebook ###
# v0.19.17

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 046663bd-bdd0-44fa-87ec-5fb68aaa30c1
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate()
	Pkg.add(url = "https://github.com/lungben/PlutoGrid.jl")
	using PlutoGrid
	using DataFrames
	using CSV
end

# ╔═╡ 2077c413-c52d-4f29-bc85-5668e0dfa68d
md"> Try to get environment right until `PlutoGrid` is published.  Arrgh."

# ╔═╡ 2f4b27af-8d14-48a9-bbeb-508e6950b3f3
pwd()

# ╔═╡ 58a683f1-11ca-4d37-bfdd-b15021fd7b59
md"""> ## PlutoGrid

"""

# ╔═╡ 52037d5a-36eb-4039-932c-37cd60d0c727
md"Read-only table"

# ╔═╡ e8a646c9-c512-4ab4-92a3-039247c724e4
md"""#### Editable?"""

# ╔═╡ a42f4fdf-9fa7-44b9-917f-06d52b575b2a
md"""> ## Load some data to test with"""

# ╔═╡ 6c248afe-cc3e-4f03-8807-b5c27c82b530
function dl_titantic()
    url = "https://www.openml.org/data/get_csv/16826755/phpMYEkMl"
    return DataFrame(CSV.File(download(url); missingstring = "?"))
end

# ╔═╡ d4a61235-0fd5-4e2f-90e8-0fe67f79932c
df = dl_titantic()

# ╔═╡ 0793c4f5-4dd8-414c-811b-da2f9ee42a92
# `:sex` property comes out as String7, and needs to be converted to a simple
# type that PlutoGrid can use -- or (as here) dropped
subdf = select(df, [:pclass, :survived, :name, :age, :fare])

# ╔═╡ ae29d375-38f0-4f8c-adf7-37f2fbd273c7
readonly_table(subdf; sortable=true, filterable=true, pagination=true, height  = 150)


# ╔═╡ d3cd6e20-5bd7-4c47-9b84-b2dfab577d2c
testset = first(subdf,10)

# ╔═╡ 6b403488-c397-4bcd-8d04-63114194eee5
@bind edits editable_table(testset; sortable=true, filterable=true, pagination=true)


# ╔═╡ 71dbdb4d-1027-423a-bbf5-70704c513f14
livedf = create_dataframe(edits)

# ╔═╡ c41af020-00be-4207-9744-38362351ee8a
md"""Number of rows in test set: **$(nrow(livedf))**"""

# ╔═╡ Cell order:
# ╟─2077c413-c52d-4f29-bc85-5668e0dfa68d
# ╠═046663bd-bdd0-44fa-87ec-5fb68aaa30c1
# ╠═2f4b27af-8d14-48a9-bbeb-508e6950b3f3
# ╟─58a683f1-11ca-4d37-bfdd-b15021fd7b59
# ╠═52037d5a-36eb-4039-932c-37cd60d0c727
# ╟─ae29d375-38f0-4f8c-adf7-37f2fbd273c7
# ╟─e8a646c9-c512-4ab4-92a3-039247c724e4
# ╟─71dbdb4d-1027-423a-bbf5-70704c513f14
# ╟─c41af020-00be-4207-9744-38362351ee8a
# ╠═6b403488-c397-4bcd-8d04-63114194eee5
# ╟─a42f4fdf-9fa7-44b9-917f-06d52b575b2a
# ╠═d3cd6e20-5bd7-4c47-9b84-b2dfab577d2c
# ╟─0793c4f5-4dd8-414c-811b-da2f9ee42a92
# ╠═d4a61235-0fd5-4e2f-90e8-0fe67f79932c
# ╟─6c248afe-cc3e-4f03-8807-b5c27c82b530
