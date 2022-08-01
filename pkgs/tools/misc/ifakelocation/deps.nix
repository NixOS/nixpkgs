{ fetchNuGet }: [
  # linux-x64 deps
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "5.0.17"; sha256 = "066fwdlssbv556zd9w1x87x1j8j4kafj9rxyy0692bssdb4gcyc8"; })
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.6"; sha256 = "0ndah9cqkgswhi60wrnni10j1d2hdg8jljij83lk1wbfqbng86jm"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "5.0.17"; sha256 = "1lc2jhr4ikffi5ylyf8f6ya6k0hdj0wp1l0017grrwd4m5ajj4vv"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.6"; sha256 = "0hvawclkpp6srhbdl0b1ma2xsvf6yy8k8s1fp4by249qzpy26w7l"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "5.0.17"; sha256 = "0jgcfs3jc98jfyaaamssznckbpnaygplk8pjsp6dswpansz5bnnq"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.6"; sha256 = "0fjbjh7yxqc9h47ix37y963xi9f9y99jvl26cw3x3kvjlb8x0bgj"; })
  # osx-x64 deps
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "5.0.17"; sha256 = "1qvvqf8mmzzc7a7fhx324dprnbxhknr3qxspb2xhsn3yyg44xn2d"; })
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.6"; sha256 = "0i00xs472gpxbrwx593z520sp8nv3lmqi8z3zrj9cshqckq8knnx"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "5.0.17"; sha256 = "02g5w41ivrw3n6cy3l3ixhcl8bw1fsv4bzs2m34k9h5fqmliaf3c"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.6"; sha256 = "12b6ya9q5wszfq6yp38lpan8zws95gbp1vs9pydk3v82gai336r3"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "5.0.17"; sha256 = "1ph5kx18syinp8bpzw80bgq3njl65gwzws727xcmxnysgm7snmjp"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.6"; sha256 = "0l15md6rzr2dvwvnk8xj1qz1dcjcbmp0aglnflrj8av60g5r1kwd"; })
  # linux-arm deps
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "5.0.17"; sha256 = "0mfawgcc23r44a1r7ynafxwga6jzn0f0z5ys03qssrvlcdsb376x"; })
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.6"; sha256 = "1fv3xvqc98l3ma4s8f2g4fklifbj1i24fngcvlhfm4j6s295xjj1"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "5.0.17"; sha256 = "0y90p765sj54clf2bwrka99w73g8b9550b4qvyilqggzydl1c1hk"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.6"; sha256 = "0kygwac98rxq89g83lyzn21kslvgdkcqfd1dnba2ssw7q056fbgy"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "5.0.17"; sha256 = "0mmgd6nacx4fzf0w02ch0qxa43vrv6wfspykxsy2bkpvrnvr8xr9"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.6"; sha256 = "088ggz1ac5z4ir707xmxiw4dlcaacfgmyvvlgwvsxhnv3fngf8b6"; })
  # linux-arm64 deps
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "5.0.17"; sha256 = "183xgqzlwd5lhacxdwcjl8vcq7r7xypv0hddps9k32mmmwf83d8h"; })
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.6"; sha256 = "1z50gqg0jimk98yd0zr2vxn087h3h1qn08fdcqbaxfgpcw30yi87"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "5.0.17"; sha256 = "07v7vyqm556xr1ypkazfp6gh6drgf20zkwbhkpja8bwdcr6lphbb"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.6"; sha256 = "0hlxq0k60ras0wj7d7q94dxd8nzjcry0kixxs6z1hyrbm4q0y3ls"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "5.0.17"; sha256 = "16whaq82pj6fqa0vam3a0va9ly843aa1z12hza040vn6252kk9fq"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.6"; sha256 = "117rz4gm7ihns5jlc2x05h7kdcgrl0ic4v67dzfbbr9kpra1bmcw"; })
  # osx-arm64 deps
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.6"; sha256 = "1qp64z6m7sr5ln3sa5b39vj73yd52zs7asqlsws3a9jpisns6vds"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.6"; sha256 = "04i4d7zhw7cqhfl84p93hpib8lhvkhmprip1li64sq5zrs36dxpx"; })
  # Common
  (fetchNuGet { pname = "iMobileDevice-net"; version = "1.2.77"; sha256 = "0qk2pb1gr31p6qxym7vwskxxkib7yvd26hbxslx2kspk0acfw4l2"; })
  (fetchNuGet { pname = "Microsoft.AspNetCore.App.Ref"; version = "5.0.0"; sha256 = "0d7sjr89zwq0wxirf8la05hfalv9nhvlczg1c7a508k8aw79jvfg"; })
  (fetchNuGet { pname = "Microsoft.NETCore.App.Ref"; version = "5.0.0"; sha256 = "1p62khf9zk23lh91lvz7plv3g1nzmm3b5szqrcm6mb8w3sjk03wi"; })
  (fetchNuGet { pname = "Microsoft.NETFramework.ReferenceAssemblies"; version = "1.0.2"; sha256 = "0i42rn8xmvhn08799manpym06kpw89qy9080myyy2ngy565pqh0a"; })
  (fetchNuGet { pname = "Microsoft.NETFramework.ReferenceAssemblies.net45"; version = "1.0.2"; sha256 = "0xq7npxd181l6ndi3ybyxi6k1qhj45cikazvyay797s94ygx405l"; })
  (fetchNuGet { pname = "MimeTypes"; version = "2.2.1"; sha256 = "1mf4pkc82b32nn4qba1m9044sa96cvbx08ghhpnq281hp04a330z"; })
  (fetchNuGet { pname = "Newtonsoft.Json"; version = "13.0.1"; sha256 = "0fijg0w6iwap8gvzyjnndds0q4b8anwxxvik7y8vgq97dram4srb"; })
  (fetchNuGet { pname = "SharpZipLib"; version = "1.3.3"; sha256 = "1gij11wfj1mqm10631cjpnhzw882bnzx699jzwhdqakxm1610q8x"; })
]
