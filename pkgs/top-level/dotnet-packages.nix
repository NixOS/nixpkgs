{ stdenv
, pkgs
, buildDotnetPackage
, fetchurl
, fetchFromGitHub
, fetchNuGet
, pkgconfig
, mono
, monodevelop
, fsharp
, unzip
, overrides ? {}
}:

let self = dotnetPackages // overrides; dotnetPackages = with self; {

  Autofac = fetchNuGet {
    baseName = "Autofac";
    version = "3.5.2";
    sha256 = "194cs8ybn5xjqnzy643w5i62m0d5s34d3nshwxp2v4fcb94wa4ri";
    outputFiles = [ "lib/portable-net4+sl5+netcore45+wpa81+wp8+MonoAndroid1+MonoTouch1/*" ];
  };

  Fake = fetchNuGet {
    baseName = "FAKE";
    version = "3.33.0";
    sha256 = "04gllx9d1w8zn9gq9p5k76b79ix07rilk3apdi72dmz6h3yylcdm";
    outputFiles = [ "tools/*" ];
    dllFiles = [ "Fake*.dll" ];
  };

  Fantomas = fetchNuGet {
    baseName = "Fantomas";
    version = "1.6.0";
    sha256 = "1b9rd3i76b5xzv0j62dvfr1ksdwvb59vxw6jhzpi018axjn6757q";
    outputFiles = [ "lib/*" ];
    dllFiles = [ "Fantomas*.dll" ];
  };

  FSharpCompilerCodeDom = fetchNuGet {
    baseName = "FSharp.Compiler.CodeDom";
    version = "0.9.2";
    sha256 = "0cy9gbvmfx2g74m7bgp6x9mr4avb6s560yjii7cyyxb7jlwabfcj";
    outputFiles = [ "lib/net40/*" ];
  };

  FsCheck = fetchNuGet {
    baseName = "FsCheck";
    version = "1.0.4";
    sha256 = "1q2wk4d4d1q94qzcccgmxb2lh0b8qkmpyz0p7lfphkw2gx6cy5ad";
    outputFiles = [ "lib/net45/*" ];
  };

  FsCheckNunit = fetchNuGet {
    baseName = "FsCheck.Nunit";
    version = "1.0.4";
    sha256 = "1s62jrsa5hxqy1ginl8r29rjdc8vbkwmz7mb0hglhwccdqfyr5xy";
    outputFiles = [ "lib/net45/*" ];
  };

  FsUnit = fetchNuGet {
    baseName = "FsUnit";
    version = "1.3.0.1";
    sha256 = "1k7w8pc81aplsfn7n46617khmzingd2v7hcgdhh7vgsssibwms64";
    outputFiles = [ "Lib/Net40/*" ];
  };

  NUnit = fetchNuGet {
    baseName = "NUnit";
    version = "2.6.4";
    sha256 = "1acwsm7p93b1hzfb83ia33145x0w6fvdsfjm9xflsisljxpdx35y";
    outputFiles = [ "lib/*" ];
  };

  NUnitRunners = fetchNuGet {
    baseName = "NUnit.Runners";
    version = "2.6.4";
    sha256 = "11nmi7vikn9idz8qcad9z7f73arsh5rw18fc1sri9ywz77mpm1s4";
    outputFiles = [ "tools/*" ];
    preInstall = "mv -v tools/lib/* tools && rmdir -v tools/lib";
  };

  SystemCollectionsImmutable = fetchNuGet {
    baseName = "System.Collections.Immutable";
    version = "1.1.36";
    sha256 = "0760kzf5s771pnvnxsgas446kqdh1b71w6g3k75jpzldfmsd3vyq";
    outputFiles = [ "lib/portable-net45+win8+wp8+wpa81/*" ];
  };

  ExtCore = buildDotnetPackage rec {
    baseName = "ExtCore";
    version = "0.8.46";

    src = fetchFromGitHub {
      owner = "jack-pappas";
      repo = "ExtCore";
      rev = "0269b6d3c479f45abd7aa983aaeca08d07473943";
      sha256 = "1kxkiszpvqisffhd6wciha8j3dhkq06w9c540bmq8zixa4xaj83p";
    };

    buildInputs = [
      fsharp
      dotnetPackages.NUnit
      dotnetPackages.FsCheck
    ];

    postConfigure = ''
      # Fix case
      sed -i -e s,nuget.targets,NuGet.targets, ExtCore.Tests/ExtCore.Tests.fsproj
    '';

    xBuildFlags = [ "/p:Configuration=Release (net45)" ];
    outputFiles = [ "ExtCore/bin/net45/Release/*" ];

    meta = {
      description = "ExtCore is an extended core library for F#";
      homepage = "https://github.com/jack-pappas/ExtCore";
      license = stdenv.lib.licenses.asl20;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  FSharpAutoComplete = buildDotnetPackage rec {
    baseName = "FSharp.AutoComplete";
    version = "0.16.0";

    src = fetchurl {
      name = "${baseName}-${version}.tar.gz";
      url = "https://github.com/fsharp/FSharp.AutoComplete/archive/${version}.tar.gz";
      sha256 = "0mwp456zfw1sjy2mafz2shx0sjn4f858pfnsmawy50g8l2znw8qg";
    };

    buildInputs = [
      fsharp
      dotnetPackages.FSharpCompilerService
      dotnetPackages.NewtonsoftJson
      dotnetPackages.NDeskOptions
    ];

    outputFiles = [ "FSharp.AutoComplete/bin/Release/*" ];

    meta = {
      description = "This project provides a command-line interface to the FSharp.Compiler.Service project. It is intended to be used as a backend service for rich editing or 'intellisense' features for editors.";
      homepage = "https://github.com/fsharp/FSharp.AutoComplete";
      license = stdenv.lib.licenses.asl20;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  FSharpCompilerService = buildDotnetPackage rec {
    baseName = "FSharp.Compiler.Service";
    version = "0.0.89";

    src = fetchFromGitHub {
      owner = "fsharp";
      repo = "FSharp.Compiler.Service";
      rev = "55a8143a82bb31c3e8c1ad2af64eb64162fed0d7";
      sha256 = "1f5f97382h8v9p0j7c2gksrps12d869m752n692b3g0k8h4zpial";
    };

    buildInputs = [
      fsharp
      dotnetPackages.NUnit
    ];

    outputFiles = [ "bin/v4.5/*" ];

    meta = {
      description = "The F# compiler services package is a component derived from the F# compiler source code that exposes additional functionality for implementing F# language bindings";
      homepage = "http://fsharp.github.io/FSharp.Compiler.Service/";
      license = stdenv.lib.licenses.asl20;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  FSharpData = buildDotnetPackage rec {
    baseName = "FSharp.Data";
    version = "2.2.2";

    src = fetchurl {
      name = "${baseName}-${version}.tar.gz";
      url = "https://github.com/fsharp/FSharp.Data/archive/${version}.tar.gz";
      sha256 = "1li33ydjxz18v8siw53vv1nmkp5w7sdlsjcrfp6dzcynpvwbjw3s";
    };

    buildInputs = [ fsharp ];

    fileProvidedTypes = fetchurl {
      name = "ProvidedTypes.fs";
      url = https://raw.githubusercontent.com/fsprojects/FSharp.TypeProviders.StarterPack/877014bfa6244ac382642e113d7cd6c9bc27bc6d/src/ProvidedTypes.fs;
      sha256 = "1lb056v1xld1rfx6a8p8i2jz8i6qa2r2823n5izsf1qg1qgf2980";
    };

    fileDebugProvidedTypes = fetchurl {
      name = "DebugProvidedTypes.fs";
      url = https://raw.githubusercontent.com/fsprojects/FSharp.TypeProviders.StarterPack/877014bfa6244ac382642e113d7cd6c9bc27bc6d/src/DebugProvidedTypes.fs;
      sha256 = "1whyrf2jv6fs7kgysn2086v15ggjsd54g1xfs398mp46m0nxp91f";
    };

    preConfigure = ''
       # Copy single-files-in-git-repos
       mkdir -p "paket-files/fsprojects/FSharp.TypeProviders.StarterPack/src"
       cp -v "${fileProvidedTypes}" "paket-files/fsprojects/FSharp.TypeProviders.StarterPack/src/ProvidedTypes.fs"
       cp -v "${fileDebugProvidedTypes}" "paket-files/fsprojects/FSharp.TypeProviders.StarterPack/src/DebugProvidedTypes.fs"
    '';

    xBuildFiles = [ "src/FSharp.Data.fsproj" "src/FSharp.Data.DesignTime.fsproj" ];
    outputFiles = [ "bin/*.dll" "bin/*.xml" ];

    meta = {
      description = "F# Data: Library for Data Access";
      homepage = "http://fsharp.github.io/FSharp.Data/";
      license = stdenv.lib.licenses.asl20;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  # FSharpxExtras = buildDotnetPackage rec {
  #   baseName = "FSharpx.Extras";
  #   version = "1.8.41";
  #
  #   src = fetchurl {
  #     name = "${baseName}-${version}.tar.gz";
  #     url = "https://github.com/fsprojects/FSharpx.Extras/archive/${version}.tar.gz";
  #     sha256 = "102z5bvk3ffi1crgyp51488vamv41fsf61n8x8pdiznq155zydhl";
  #   };
  #
  #   buildInputs = [
  #     fsharp
  #     dotnetPackages.NUnit
  #     dotnetPackages.FsCheck
  #     dotnetPackages.FsCheckNunit
  #     dotnetPackages.FsUnit
  #   ];
  #
  #   patches = [ ./disable_excel.patch ];
  #
  #   xBuildFiles = [ "FSharpx.WithTypeProviders.sln" ];
  #   outputFiles = [ "build/*" ];
  #
  #   meta = {
  #     description = "FSharpx.Extras is a collection of libraries and tools for use with F#.";
  #     homepage = "http://fsprojects.github.io/FSharpx.Extras/";
  #     license = stdenv.lib.licenses.asl20;
  #     maintainers = with stdenv.lib.maintainers; [ obadz ];
  #     platforms = with stdenv.lib.platforms; linux;
  #   };
  # };

  MonoDevelopFSharpBinding = buildDotnetPackage rec {
    baseName = "MonoDevelop.FSharpBinding";
    version = "git-a09c8185eb";

    src = fetchFromGitHub {
      owner = "fsharp";
      repo = "fsharpbinding";
      rev = "a09c8185ebf23fe2f7d22b14b4af2e3268d4f011";
      sha256 = "1zp5gig42s1h681kch0rw5ykbbj0mcsmdvpyz1319wy9s7n2ng91";
    };

    buildInputs = [
      fsharp
      monodevelop
      pkgs.gtk-sharp
      pkgs.gnome-sharp
      dotnetPackages.ExtCore
      dotnetPackages.FSharpCompilerService
      dotnetPackages.FSharpCompilerCodeDom
      dotnetPackages.FSharpAutoComplete
      dotnetPackages.Fantomas
    ];

    patches = [
      ../development/dotnet-modules/patches/monodevelop-fsharpbinding.references.patch
      ../development/dotnet-modules/patches/monodevelop-fsharpbinding.addin-xml.patch
    ];

    preConfigure = ''
      substituteInPlace monodevelop/configure.fsx --replace /usr/lib/monodevelop ${monodevelop}/lib/monodevelop
      substituteInPlace monodevelop/configure.fsx --replace bin/MonoDevelop.exe ../../bin/monodevelop
      (cd monodevelop; fsharpi ./configure.fsx)
    '';

    # This will not work as monodevelop probably looks in absolute nix store path rather than path
    # relative to its executable. Need to ln -s /run/current-system/sw/lib/dotnet/MonoDevelop.FSharpBinding
    # ~/.local/share/MonoDevelop-5.0/LocalInstall/Addins/ to install until we have a better way

    # postInstall = ''
    #   mkdir -p "$out/lib/monodevelop/AddIns"
    #   ln -sv "$out/lib/dotnet/${baseName}" "$out/lib/monodevelop/AddIns"
    # '';

    xBuildFiles = [ "monodevelop/MonoDevelop.FSharpBinding/MonoDevelop.FSharp.mac-linux.fsproj" ];
    outputFiles = [ "monodevelop/bin/mac-linux/Release/*" ];

    meta = {
      description = "F# addin for MonoDevelop 5.9";
      homepage = "https://github.com/fsharp/fsharpbinding/tree/5.9";
      license = stdenv.lib.licenses.asl20;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  NDeskOptions = stdenv.mkDerivation rec {
    baseName = "NDesk.Options";
    version = "0.2.1";
    name = "${baseName}-${version}";

    src = fetchurl {
      name = "${baseName}-${version}.tar.gz";
      url = "http://www.ndesk.org/archive/ndesk-options/ndesk-options-0.2.1.tar.gz";
      sha256 = "1y25bfapafwmifakjzyb9c70qqpvza8g5j2jpf08j8wwzkrb6r28";
    };

    buildInputs = [
      mono
      pkgconfig
    ];

    preConfigure = ''
      substituteInPlace configure --replace gmcs mcs
    '';

    postInstall = ''
      # Otherwise pkg-config won't find it and the DLL will get duplicated
      ln -sv $out/lib/pkgconfig/ndesk-options.pc $out/lib/pkgconfig/NDesk.Options.pc
    '';

    dontStrip = true;

    meta = {
      description = "NDesk.Options is a callback-based program option parser for C#.";
      homepage = "http://www.ndesk.org/Options";
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  NewtonsoftJson = buildDotnetPackage rec {
    baseName = "Newtonsoft.Json";
    version = "6.0.8";

    src = fetchurl {
      name = "${baseName}-${version}.tar.gz";
      url = "https://github.com/JamesNK/Newtonsoft.Json/archive/${version}.tar.gz";
      sha256 = "14znf5mycka578bxjnlnz6a3f9nfkc682hgmgg42gdzksnarvhlm";
    };

    buildInputs = [
      fsharp
      dotnetPackages.NUnit
      dotnetPackages.SystemCollectionsImmutable
      dotnetPackages.Autofac
    ];

    patches = [ ../development/dotnet-modules/patches/newtonsoft-json.references.patch ];

    postConfigure = ''
       # Just to make sure there's no attempt to call these executables
       rm -rvf Tools
    '';

    xBuildFiles = [ "Src/Newtonsoft.Json.sln" ];
    outputFiles = [ "Src/Newtonsoft.Json/bin/Release/Net45/*" ];

    meta = {
      description = "Popular high-performance JSON framework for .NET";
      homepage = "http://www.newtonsoft.com/json";
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  Nuget = buildDotnetPackage {
    baseName = "Nuget";
    version = "2.8.5";

    src = fetchFromGitHub {
      owner = "mono";
      repo = "nuget-binary";
      rev = "da1f2102f8172df6f7a1370a4998e3f88b91c047";
      sha256 = "1hbnckc4gvqkknf8gh1k7iwqb4vdzifdjd19i60fnczly5v8m1c3";
    };

    buildInputs = [ unzip ];

    phases = [ "unpackPhase" "installPhase" ];

    outputFiles = [ "*" ];
    dllFiles = [ "NuGet*.dll" ];
    exeFiles = [ "NuGet.exe" ];
  };

  Paket = buildDotnetPackage rec {
    baseName = "Paket";
    version = "1.6.2";

    src = fetchurl {
      name = "${baseName}-${version}.tar.gz";
      url = "https://github.com/fsprojects/Paket/archive/${version}.tar.gz";
      sha256 = "1ryslxdgc3r7kcn1gq4bqcyrqdi8z6364aj3lr7yjz71wi22fca8";
    };

    buildInputs = [
      fsharp
      dotnetPackages.NewtonsoftJson
      dotnetPackages.UnionArgParser
      dotnetPackages.NUnit
    ];

    fileFsUnit = fetchurl {
      name = "FsUnit.fs";
      url = https://raw.githubusercontent.com/forki/FsUnit/81d27fd09575a32c4ed52eadb2eeac5f365b8348/FsUnit.fs;
      sha256 = "1zxigqgb2s2v755622jbbzibvf91990x2dijhbdgg646vsybkpdp";
    };

    # fileOctokit = fetchurl {
    #   name = "Octokit.fsx";
    #   url = https://raw.githubusercontent.com/fsharp/FAKE/8e65e2fc1406f326b44f3f87ec9ca9b3127a6e78/modules/Octokit/Octokit.fsx;
    #   sha256 = "16qxwmgyg3fn3z9a8hppv1m579828x7lvfj8qflcgs2g6ciagsir";
    # };

    fileGlobbing = fetchurl {
      name = "Globbing.fs";
      url = https://raw.githubusercontent.com/fsharp/FAKE/8e65e2fc1406f326b44f3f87ec9ca9b3127a6e78/src/app/FakeLib/Globbing/Globbing.fs;
      sha256 = "1v7d7666a61j6f8ksh0q40hfsc5b03448viq17xa91xgb7skhyx7";
    };

    fileErrorHandling = fetchurl {
      name = "ErrorHandling.fs";
      url = https://raw.githubusercontent.com/fsprojects/Chessie/3017092260b4a59a3b4b25bf8fca6be6eb7487eb/src/Chessie/ErrorHandling.fs;
      sha256 = "0ka9ilfbl4izxc1wqd5vlfjnp7n2xcckfhp13gzhqbdx7464van9";
    };

    postConfigure = ''
       # Copy said single-files-in-git-repos
       mkdir -p "paket-files/forki/FsUnit"
       cp -v "${fileFsUnit}" "paket-files/forki/FsUnit/FsUnit.fs"

       mkdir -p "paket-files/fsharp/FAKE/src/app/FakeLib/Globbing"
       cp -v "${fileGlobbing}" "paket-files/fsharp/FAKE/src/app/FakeLib/Globbing/Globbing.fs"

       mkdir -p "paket-files/fsprojects/Chessie/src/Chessie"
       cp -v "${fileErrorHandling}" "paket-files/fsprojects/Chessie/src/Chessie/ErrorHandling.fs"
    '';

    xBuildFiles = [ ];

    outputFiles = [ "bin/*" ];
    exeFiles = [ "paket.exe" ];

    meta = {
      description = "A dependency manager for .NET and Mono projects";
      homepage = "http://fsprojects.github.io/Paket/";
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  UnionArgParser = buildDotnetPackage rec {
    baseName = "UnionArgParser";
    version = "0.8.7";

    src = fetchFromGitHub {
      owner = "nessos";
      repo = "UnionArgParser";
      rev = "acaeb946e53cbb0bd9768977c656b3242146070a";
      sha256 = "1yrs7ycf2hg7h8z6vm9lr7i3gr9s30k74fr2maigdydnnls93als";
    };

    buildInputs = [
      fsharp
      dotnetPackages.NUnit
      dotnetPackages.FsUnit
    ];

    outputFiles = [ "bin/net40/*" ];

    meta = {
      description = "A declarative CLI argument/XML configuration parser for F# applications.";
      homepage = "http://nessos.github.io/UnionArgParser/";
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };
}; in self
