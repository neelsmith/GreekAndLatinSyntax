### A Pluto.jl notebook ###
# v0.19.13

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

# ╔═╡ 90575372-7665-11ed-26a7-f507ba76236a
using PlutoUI

# ╔═╡ 30743c2e-f64a-4eaa-9c1b-51cee4f52e81
	data = Base.RefValue{Vector{String}}([""])

# ╔═╡ 1cbbc199-1d86-4f62-a539-c725d7bca090
# Check that we defined this right:
typeof(data)

# ╔═╡ 08fa5f55-3110-4291-8a57-9d7033d7a495
md"""> ## Everything below here is a working example of dynamically editing a vector of strings
>
> This functionality could be used in a real UI.
"""

# ╔═╡ 43507a34-d4ca-43a7-898d-44b4c8edc8b2
md"""> *Start by initializing a new vector with a default value*: 

$(@bind initialize Button("initialize"))
"""

# ╔═╡ 9913eedc-b7f1-43ec-a26a-de03faab9e17
# Initialize data array
begin 
	initialize
	data[] =  ["Initial value"]
end

# ╔═╡ c4fcd31d-cf18-449e-a4e2-c9a9810db736
md"""### Display the current value"""

# ╔═╡ 2600da2d-c424-403b-ae12-f588c203b275
md"*This is the current value of the edited vector:*"

# ╔═╡ 259da334-2433-45f4-9cf7-e5d9628c0b5e
md"""> *To add a new element*
> 
> 1. Enter a new value, and confirm with `Submit`
> 2. Use the `add record` button to add it to the data vector

"""

# ╔═╡ ca9e23dd-3f09-400f-94b6-f7ea73db1ddc
@bind newrec Button("add record")

# ╔═╡ 8a01bf30-e45d-43f1-8e18-6d947128cb26
md"""> *To modify an existing element*:
>
> 1. choose an element from the `Choose element to modify` list
> 2. enter a new value (above), and confirm with `Submit`
> 3. `update record`

"""

# ╔═╡ 642906e7-9dab-424e-ba5c-02f323e5db2e
begin

	md"""

	$(@bind updaterec Button("update record"))

	
	"""
end

# ╔═╡ 881ff6f9-247c-4ad9-a8f1-2ad65ed28498
md"""> *To delete an element*
>
> 1. choose an element from the `Choose element to modify` list
> 2. use the `delete record` button
"""

# ╔═╡ fcb91aa9-b9d0-4885-94d1-467323d9f9bb
@bind deleterec Button("delete record")

# ╔═╡ b91211c7-fb01-4849-a96e-ce7410d1f2d4
let initialize, deleterec, updaterec, newrec 
	data[]
end

# ╔═╡ e300b0a4-65c2-4e72-b4c0-aaaf376bdf18
begin initialize, deleterec, updaterec, newrec
	#md"""Compare `elidx` $(elidx) with length of data $(length(data))

	md"""*Enter new value*:
	$(@bind editbox confirm(TextField(placeholder = "(no element selected)")))
	"""
	#defaultval = elidx > 1 ? data[][elidx] : ""
	#md"""*Enter new value*: $(@bind editbox confirm(TextField(default = defaultval, placeholder = "(no element selected)")))"""
end

# ╔═╡ 7d0c1c79-c904-4cbd-87f4-d449b78fa2f9
# Add a new, non-empty entry to the data vector
begin 
	newrec
	if !isempty(editbox)
		push!(data[], editbox)
	end
end

# ╔═╡ 2f26778d-a039-4e7e-9cc8-e9a1c92b5785
html"""


<br/><br/><br/><br/><br/><br/><br/>
<hr/>
"""

# ╔═╡ 8ce1efff-afc8-4165-81d8-d993bb2425da
md"""> Some stuff that helps me debug initial version"""

# ╔═╡ 397bc584-af57-45ca-9a89-1f67d45412af
editbox

# ╔═╡ bbf276d4-4947-47fa-984c-8d416ae65d90
menuopts = begin initialize, newrec,  updaterec,  deleterec
	optlist = [0 => ""]
	for (i, s) in enumerate(data[])
		push!(optlist, i => s)
	end
	optlist
end

# ╔═╡ 8ff5b6ec-ac4e-4c41-8184-045f4b9b7e98
begin
	
md"""*Choose element to modify*: 
$(@bind elidx Select(menuopts))
"""
end

# ╔═╡ 6d425f6d-42a0-4a8d-99c6-0c097a35027a
# Delete selected element
begin 
	deleterec
	if ! isempty(data[]) && elidx > 0
		deleteat!(data[], elidx)
	end
end

# ╔═╡ 84b8bcd4-e8a5-4007-a8d5-2a9a7de31597
# Update value of existing element
begin 
	updaterec

	if isempty(editbox)
		#do nothing
	elseif elidx == 0
		# do nothing
	else
		#push!(data[],  "Another")
		data[][elidx] = editbox
	end
end

# ╔═╡ 98f63352-c9a2-400f-8993-ba8d630b7d28
begin initialize, deleterec, updaterec, newrec
	md"""Compare `elidx` $(elidx) with length of data $(length(data[]))"""
end

# ╔═╡ a0386f13-fa70-41eb-bd5a-a4d46511e1d6
md"This is the length of the vector:"

# ╔═╡ d1ab6b4e-9607-4f58-a2f3-c79360991564
let initialize, deleterec, updaterec, newrec 
	data[] |> length
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.1"
manifest_format = "2.0"
project_hash = "08cc58b1fbde73292d848136b97991797e6c5429"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "b64719e8b4504983c7fca6cc9db3ebc8acc2a4d6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═90575372-7665-11ed-26a7-f507ba76236a
# ╟─30743c2e-f64a-4eaa-9c1b-51cee4f52e81
# ╟─1cbbc199-1d86-4f62-a539-c725d7bca090
# ╟─9913eedc-b7f1-43ec-a26a-de03faab9e17
# ╠═6d425f6d-42a0-4a8d-99c6-0c097a35027a
# ╠═84b8bcd4-e8a5-4007-a8d5-2a9a7de31597
# ╠═7d0c1c79-c904-4cbd-87f4-d449b78fa2f9
# ╟─08fa5f55-3110-4291-8a57-9d7033d7a495
# ╟─43507a34-d4ca-43a7-898d-44b4c8edc8b2
# ╟─c4fcd31d-cf18-449e-a4e2-c9a9810db736
# ╟─2600da2d-c424-403b-ae12-f588c203b275
# ╟─b91211c7-fb01-4849-a96e-ce7410d1f2d4
# ╟─259da334-2433-45f4-9cf7-e5d9628c0b5e
# ╟─e300b0a4-65c2-4e72-b4c0-aaaf376bdf18
# ╟─ca9e23dd-3f09-400f-94b6-f7ea73db1ddc
# ╟─8a01bf30-e45d-43f1-8e18-6d947128cb26
# ╟─8ff5b6ec-ac4e-4c41-8184-045f4b9b7e98
# ╟─642906e7-9dab-424e-ba5c-02f323e5db2e
# ╟─881ff6f9-247c-4ad9-a8f1-2ad65ed28498
# ╟─fcb91aa9-b9d0-4885-94d1-467323d9f9bb
# ╟─2f26778d-a039-4e7e-9cc8-e9a1c92b5785
# ╟─8ce1efff-afc8-4165-81d8-d993bb2425da
# ╠═397bc584-af57-45ca-9a89-1f67d45412af
# ╟─98f63352-c9a2-400f-8993-ba8d630b7d28
# ╟─bbf276d4-4947-47fa-984c-8d416ae65d90
# ╟─a0386f13-fa70-41eb-bd5a-a4d46511e1d6
# ╟─d1ab6b4e-9607-4f58-a2f3-c79360991564
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
