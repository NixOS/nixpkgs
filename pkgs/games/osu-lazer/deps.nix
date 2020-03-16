{ fetchurl }: let

  fetchNuGet = { name, version, sha256 }: fetchurl {
    inherit sha256;
    url = "https://www.nuget.org/api/v2/package/${name}/${version}";
  };

in [

  (fetchNuGet {
    name = "Humanizer";
    version = "2.7.9";
    sha256 = "01197gpk6m5djbh0nw6hgx5vgcimq826frr6397g84i1gm0lkij2";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.EntityFrameworkCore.Sqlite";
    version = "2.2.6";
    sha256 = "0z8k5ns841imaqha5abb1ka0rsfzy90k6qkrvix11sp6k9i7lsam";
  })

  (fetchNuGet {
    name = "Microsoft.EntityFrameworkCore.Sqlite.Core";
    version = "2.2.6";
    sha256 = "0jzqw4672mzxjvzas09sl0zyzzayfgkv003a7bw5g2gjyiphf630";
  })

  (fetchNuGet {
    name = "Newtonsoft.Json";
    version = "12.0.3";
    sha256 = "17dzl305d835mzign8r15vkmav2hq8l6g7942dfjpnzr17wwl89x";
  })

  (fetchNuGet {
    name = "NUnit";
    version = "3.12.0";
    sha256 = "1880j2xwavi8f28vxan3hyvdnph4nlh5sbmh285s4lc9l0b7bdk2";
  })

  (fetchNuGet {
    name = "ppy.osu.Framework";
    version = "2020.305.0";
    sha256 = "0ia09ckwr3qv9qvfyl05bmg77sqv18z0c70yhvhk5ldpsrpragj9";
  })

  (fetchNuGet {
    name = "ppy.osu.Game.Resources";
    version = "2020.304.0";
    sha256 = "125x0m17v2czr2cakwlqnfja6kvxzw6ivschr1f11w5kskv13i3y";
  })

  (fetchNuGet {
    name = "Sentry";
    version = "2.1.0";
    sha256 = "14dsr6fgysn8w2mj179i2klb72b7lbmsk99zlqcqic054j641ccr";
  })

  (fetchNuGet {
    name = "SharpCompress";
    version = "0.24.0";
    sha256 = "13bzq8ggipr5254654l2ndm6jdxj9ggandy01gpjxnjwy4jhaz9p";
  })

  (fetchNuGet {
    name = "System.ComponentModel.Annotations";
    version = "4.7.0";
    sha256 = "06x1m46ddxj0ng28d7gry9gjkqdg2kp89jyf480g5gznyybbs49z";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Appveyor.TestLogger";
    version = "2.0.0";
    sha256 = "1x2hizldz5wlnjybp115r7npmqw0i9mdpq38wdlibrlq1338g0s9";
  })

  (fetchNuGet {
    name = "DeepEqual";
    version = "2.0.0";
    sha256 = "11j9a6ld7fn10w0i34c9vbw0h51r9wwyzg87b76rjhw050svbk71";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.NET.Test.Sdk";
    version = "16.5.0";
    sha256 = "19f5bvzci5mmfz81jwc4dax4qdf7w4k67n263383mn8mawf22bfq";
  })

  (fetchNuGet {
    name = "NUnit";
    version = "3.12.0";
    sha256 = "1880j2xwavi8f28vxan3hyvdnph4nlh5sbmh285s4lc9l0b7bdk2";
  })

  (fetchNuGet {
    name = "NUnit3TestAdapter";
    version = "3.15.1";
    sha256 = "1nhpvzxbxgymmkb3bd5ci40rg8k71bfx2ghbgc99znvnvhf2034y";
  })

  (fetchNuGet {
    name = "DiscordRichPresence";
    version = "1.0.150";
    sha256 = "0qmbi4sccia3w80q8xfvj3bw62nvz047wq198n2b2aflkf47bq79";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.EntityFrameworkCore.Design";
    version = "2.2.6";
    sha256 = "0kjjkh1yfb56wnkmciqzfn9vymqfjap364y5amia0lmqmhfz8g7f";
  })

  (fetchNuGet {
    name = "Microsoft.EntityFrameworkCore.Sqlite";
    version = "2.2.6";
    sha256 = "0z8k5ns841imaqha5abb1ka0rsfzy90k6qkrvix11sp6k9i7lsam";
  })

  (fetchNuGet {
    name = "Microsoft.Win32.Registry";
    version = "4.7.0";
    sha256 = "0bx21jjbs7l5ydyw4p6cn07chryxpmchq2nl5pirzz4l3b0q4dgs";
  })

  (fetchNuGet {
    name = "ppy.squirrel.windows";
    version = "1.9.0.4";
    sha256 = "1m8shcmgs0fs225qd0navr1qr6csqjin9sg2x0d7xpfk04nd2hi7";
  })

  (fetchNuGet {
    name = "System.IO.Packaging";
    version = "4.7.0";
    sha256 = "1vivvf158ilcpp6bq70zyafimi0lng546b34csmjb09k19wgxpiv";
  })

  (fetchNuGet {
    name = "Appveyor.TestLogger";
    version = "2.0.0";
    sha256 = "1x2hizldz5wlnjybp115r7npmqw0i9mdpq38wdlibrlq1338g0s9";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.NET.Test.Sdk";
    version = "16.5.0";
    sha256 = "19f5bvzci5mmfz81jwc4dax4qdf7w4k67n263383mn8mawf22bfq";
  })

  (fetchNuGet {
    name = "NUnit";
    version = "3.12.0";
    sha256 = "1880j2xwavi8f28vxan3hyvdnph4nlh5sbmh285s4lc9l0b7bdk2";
  })

  (fetchNuGet {
    name = "NUnit3TestAdapter";
    version = "3.15.1";
    sha256 = "1nhpvzxbxgymmkb3bd5ci40rg8k71bfx2ghbgc99znvnvhf2034y";
  })

  (fetchNuGet {
    name = "Appveyor.TestLogger";
    version = "2.0.0";
    sha256 = "1x2hizldz5wlnjybp115r7npmqw0i9mdpq38wdlibrlq1338g0s9";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.NET.Test.Sdk";
    version = "16.5.0";
    sha256 = "19f5bvzci5mmfz81jwc4dax4qdf7w4k67n263383mn8mawf22bfq";
  })

  (fetchNuGet {
    name = "NUnit";
    version = "3.12.0";
    sha256 = "1880j2xwavi8f28vxan3hyvdnph4nlh5sbmh285s4lc9l0b7bdk2";
  })

  (fetchNuGet {
    name = "NUnit3TestAdapter";
    version = "3.15.1";
    sha256 = "1nhpvzxbxgymmkb3bd5ci40rg8k71bfx2ghbgc99znvnvhf2034y";
  })

  (fetchNuGet {
    name = "Appveyor.TestLogger";
    version = "2.0.0";
    sha256 = "1x2hizldz5wlnjybp115r7npmqw0i9mdpq38wdlibrlq1338g0s9";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.NET.Test.Sdk";
    version = "16.5.0";
    sha256 = "19f5bvzci5mmfz81jwc4dax4qdf7w4k67n263383mn8mawf22bfq";
  })

  (fetchNuGet {
    name = "NUnit";
    version = "3.12.0";
    sha256 = "1880j2xwavi8f28vxan3hyvdnph4nlh5sbmh285s4lc9l0b7bdk2";
  })

  (fetchNuGet {
    name = "NUnit3TestAdapter";
    version = "3.15.1";
    sha256 = "1nhpvzxbxgymmkb3bd5ci40rg8k71bfx2ghbgc99znvnvhf2034y";
  })

  (fetchNuGet {
    name = "Appveyor.TestLogger";
    version = "2.0.0";
    sha256 = "1x2hizldz5wlnjybp115r7npmqw0i9mdpq38wdlibrlq1338g0s9";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.NET.Test.Sdk";
    version = "16.5.0";
    sha256 = "19f5bvzci5mmfz81jwc4dax4qdf7w4k67n263383mn8mawf22bfq";
  })

  (fetchNuGet {
    name = "NUnit";
    version = "3.12.0";
    sha256 = "1880j2xwavi8f28vxan3hyvdnph4nlh5sbmh285s4lc9l0b7bdk2";
  })

  (fetchNuGet {
    name = "NUnit3TestAdapter";
    version = "3.15.1";
    sha256 = "1nhpvzxbxgymmkb3bd5ci40rg8k71bfx2ghbgc99znvnvhf2034y";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.Win32.Registry";
    version = "4.7.0";
    sha256 = "0bx21jjbs7l5ydyw4p6cn07chryxpmchq2nl5pirzz4l3b0q4dgs";
  })

  (fetchNuGet {
    name = "Appveyor.TestLogger";
    version = "2.0.0";
    sha256 = "1x2hizldz5wlnjybp115r7npmqw0i9mdpq38wdlibrlq1338g0s9";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.BannedApiAnalyzers";
    version = "2.9.8";
    sha256 = "14krjfmvxph21hiw29p3849gydqyr8v541ibgc3833j8rw74mkxr";
  })

  (fetchNuGet {
    name = "Microsoft.CodeAnalysis.FxCopAnalyzers";
    version = "2.9.8";
    sha256 = "15zv982rln15ds8z2hkpmx04njdg0cmmf1xnb9v1v7cxxf7yxx27";
  })

  (fetchNuGet {
    name = "Microsoft.NET.Test.Sdk";
    version = "16.5.0";
    sha256 = "19f5bvzci5mmfz81jwc4dax4qdf7w4k67n263383mn8mawf22bfq";
  })

  (fetchNuGet {
    name = "NUnit";
    version = "3.12.0";
    sha256 = "1880j2xwavi8f28vxan3hyvdnph4nlh5sbmh285s4lc9l0b7bdk2";
  })

  (fetchNuGet {
    name = "NUnit3TestAdapter";
    version = "3.15.1";
    sha256 = "1nhpvzxbxgymmkb3bd5ci40rg8k71bfx2ghbgc99znvnvhf2034y";
  })

]
