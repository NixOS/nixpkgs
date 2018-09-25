{ stdenv
, pkgs
, buildDotnetPackage
, fetchurl
, fetchFromGitHub
, fetchNuGet
, pkgconfig
, mono
, fsharp
, unzip
, overrides ? {}
}:

let self = dotnetPackages // overrides; dotnetPackages = with self; {

  # BINARY PACKAGES

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

  FSharpCore = fetchNuGet {
    baseName = "FSharp.Core";
    version = "4.0.0.1";
    sha256 = "01nhjcxdz8l1r5vvdzhmgy5x7z5fqppab3ki34qg14axgf8jjygn";
    outputFiles = [ "*" ];
  };

  FSharpData225 = fetchNuGet {
    baseName = "FSharp.Data";
    version = "2.2.5";
    sha256 = "1c9l6bk0d2srccash2980y9phq3kmfm0m76k4wghnysnq94vm724";
    outputFiles = [ "*" ];
  };

  FSharpDataSQLProvider = fetchNuGet {
    baseName = "SQLProvider";
    version = "0.0.9-alpha";
    sha256 = "1wmgr5ca9hh6a7f0s8yc87n6arn7bq6nwc8n4crbbdil4r0bw46w";
    outputFiles = [ "lib/net40/*" ];
  };

  FsCheck = fetchNuGet {
    baseName = "FsCheck";
    version = "1.0.4";
    sha256 = "1q2wk4d4d1q94qzcccgmxb2lh0b8qkmpyz0p7lfphkw2gx6cy5ad";
    outputFiles = [ "lib/net45/*" ];
  };

  FsCheck262 = fetchNuGet {
    baseName = "FsCheck";
    version = "2.6.2";
    sha256 = "0fh9yvsc4i61z31qf00d6gjv6xxd54pv1ykf5bpv95a5crc3qfvl";
    outputFiles = [ "*" ];
  };

  FsCheckNunit = fetchNuGet {
    baseName = "FsCheck.Nunit";
    version = "1.0.4";
    sha256 = "1s62jrsa5hxqy1ginl8r29rjdc8vbkwmz7mb0hglhwccdqfyr5xy";
    outputFiles = [ "lib/net45/*" ];
  };

  FSharpCompilerTools = fetchNuGet {
    baseName = "FSharp.Compiler.Tools";
    version = "4.1.4";
    sha256 = "0vsp0khlnwh15ibg8s161rw6a6i8rlriclpq53paga447jllf0m8";
    outputFiles = [ "*" ];
  };

  FsLexYacc = fetchNuGet {
    baseName = "FsLexYacc";
    version = "6.1.0";
    sha256 = "1v5myn62zqs431i046gscqw2v0c969fc7pdplx7z9cnpy0p2s4rv";
    outputFiles = [ "build/*" ];
  };

  FsLexYacc704 = fetchNuGet {
    baseName = "FsLexYacc";
    version = "7.0.4";
    sha256 = "01zpdb0pybdf0by02rwd7pb1g0cmnn8jxm2pibzxjxw6f4l43ywi";
    outputFiles = [ "*" ];
  };

  FsPickler = fetchNuGet {
    baseName = "FsPickler";
    version = "1.2.9";
    sha256 = "12fgcj7pvffsj1s1kaz15j22i1n98dy5mf4z84555xdf7mw7dpm4";
    outputFiles = [ "lib/net45/*" ];
  };

  FsUnit = fetchNuGet {
    baseName = "FsUnit";
    version = "1.3.0.1";
    sha256 = "1k7w8pc81aplsfn7n46617khmzingd2v7hcgdhh7vgsssibwms64";
    outputFiles = [ "Lib/Net40/*" ];
  };

  FSharpFormatting = fetchNuGet {
    baseName = "FSharp.Formatting";
    version = "2.9.8";
    sha256 = "1bswcpa68i2lqds4kkl2qxgkfrppbpxa4jkyja48azljajh0df3m";
    outputFiles = [ "lib/net40/*" ];
  };

  NUnit3 = fetchNuGet {
    baseName = "NUnit";
    version = "3.0.1";
    sha256 = "1g3j3kvg9vrapb1vjgq65nvn1vg7bzm66w7yjnaip1iww1yn1b0p";
    outputFiles = [ "lib/*" ];
  };

  NUnit350 = fetchNuGet {
    baseName = "NUnit";
    version = "3.5.0";
    sha256 = "19fxq9cf754ygda5c8rn1zqs71pfxi7mb96jwqhlichnqih6i16z";
    outputFiles = [ "*" ];
  };

  NUnit2 = fetchNuGet {
    baseName = "NUnit";
    version = "2.6.4";
    sha256 = "1acwsm7p93b1hzfb83ia33145x0w6fvdsfjm9xflsisljxpdx35y";
    outputFiles = [ "lib/*" ];
  };

  NUnit = NUnit2;

  NUnitConsole = fetchNuGet {
    baseName = "NUnit.Console";
    version = "3.0.1";
    sha256 = "154bqwm2n95syv8nwd67qh8qsv0b0h5zap60sk64z3kd3a9ffi5p";
    outputFiles = [ "tools/*" ];
  };

  MaxMindDb = fetchNuGet {
    baseName = "MaxMind.Db";
    version = "1.1.0.0";
    sha256 = "0lixl76f7k3ldiqzg94zh13gn82w5mm5dx72y97fcqvp8g6nj3ds";
    outputFiles = [ "lib/*" ];
  };

  MaxMindGeoIP2 = fetchNuGet {
    baseName = "MaxMind.GeoIP2";
    version = "2.3.1";
    sha256 = "1s44dvjnmj1aimbrgkmpj6h5dn1w6acgqjch1axc76yz6hwknqgf";
    outputFiles = [ "lib/*" ];
  };

  SharpZipLib = fetchNuGet {
    baseName = "SharpZipLib";
    version = "0.86.0";
    sha256 = "01w2038gckfnq31pncrlgm7d0c939pwr1x4jj5450vcqpd4c41jr";
    outputFiles = [ "lib/*" ];
  };

  StyleCopMSBuild = fetchNuGet {
    baseName = "StyleCop.MSBuild";
    version = "4.7.49.0";
    sha256 = "0rpfyvcggm881ynvgr17kbx5hvj7ivlms0bmskmb2zyjlpddx036";
    outputFiles = [ "tools/*" ];
  };

  StyleCopPlusMSBuild = fetchNuGet {
    baseName = "StyleCopPlus.MSBuild";
    version = "4.7.49.5";
    sha256 = "1hv4lfxw72aql8siyqc4n954vzdz8p6jx9f2wrgzz0jy1k98x2mr";
    outputFiles = [ "tools/*" ];
  };

  SystemValueTuple = fetchNuGet {
    baseName = "System.ValueTuple";
    version = "4.3.0";
    sha256 = "00p5s753xh5417arw3k6npf1pc1k3m1s9mrlkw5vmc7pg8lm6n88";
    outputFiles = [ "*" ];
  };

  RestSharp = fetchNuGet {
    baseName = "RestSharp";
    version = "105.2.3";
    sha256 = "1br48124ppz80x92m84sfyil1gn23hxg2ml9i9hsd0lp86vlaa1m";
    outputFiles = [ "lib/*" ];
  };

  SharpFont = fetchNuGet {
    baseName = "SharpFont";
    version = "3.1.0";
    sha256 = "137y514i4zi0i0qsx7nv4ibl4kifbr8xr23rqdkwf7yxf88jjmh2";
    outputFiles = [ "lib/*" "config/*" ];
  };

  SmartIrc4net = fetchNuGet {
    baseName = "SmartIrc4net";
    version = "0.4.5.1";
    sha256 = "1d531sj39fvwmj2wgplqfify301y3cwp7kwr9ai5hgrq81jmjn2b";
    outputFiles = [ "lib/*" ];
  };

  FuzzyLogicLibrary = fetchNuGet {
    baseName = "FuzzyLogicLibrary";
    version = "1.2.0";
    sha256 = "0x518i8d3rw9n51xwawa4sywvqd722adj7kpcgcm63r66s950r5l";
    outputFiles = [ "bin/*" ];
  };

  OpenNAT = fetchNuGet {
    baseName = "Open.NAT";
    version = "2.1.0";
    sha256 = "1jyd30fwycdwx5ck96zhp2xf20yz0sp7g3pjbqhmay4kd322mfwk";
    outputFiles = [ "lib/*" ];
  };

  MonoNat = fetchNuGet {
    baseName = "Mono.Nat";
    version = "1.2.24";
    sha256 = "0vfkach11kkcd9rcqz3s38m70d5spyb21gl99iqnkljxj5555wjs";
    outputFiles = [ "lib/*" ];
  };

  MicrosoftDiaSymReader = fetchNuGet {
    baseName = "Microsoft.DiaSymReader";
    version = "1.1.0";
    sha256 = "04dgwy6nyxksd1nb24k5c5vz8naggg7hryadvwqnm2v3alkh6g88";
    outputFiles = [ "*" ];
  };

  MicrosoftDiaSymReaderPortablePdb = fetchNuGet {
    baseName = "Microsoft.DiaSymReader.PortablePdb";
    version = "1.2.0";
    sha256 = "0qa8sqg0lzz9galkkfyi8rkbkali0nxm3qd5y4dlxp96ngrq5ldz";
    outputFiles = [ "*" ];
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

  SystemCollectionsImmutable131 = fetchNuGet {
    baseName = "System.Collections.Immutable";
    version = "1.3.1";
    sha256 = "149fcp7k7r9iw24dv5hbaij0c38kcv28dyhzbkggilfh4x2hy8c2";
    outputFiles = [ "*" ];
  };

  SystemReflectionMetadata = fetchNuGet {
    baseName = "System.Reflection.Metadata";
    version = "1.4.2";
    sha256 = "19fhdgd35yg52gyckhgwrphq07nv7v7r73hcg69ns94xfg1i6r7i";
    outputFiles = [ "*" ];
  };

  Suave = fetchNuGet {
    baseName = "Suave";
    version = "0.29.0";
    propagatedBuildInputs = [ FsPickler ];
    sha256 = "0rgqy0afwm50gq5ca94w16s565yx5wf961683ghfld6ir0k3dhln";
    outputFiles = [ "lib/net40/*" ];
  };

  # SOURCE PACKAGES

  Boogie = buildDotnetPackage rec {
    baseName = "Boogie";
    version = "2018-05-28";
    name = "${baseName}-unstable-${version}";

    src = fetchFromGitHub {
      owner = "boogie-org";
      repo = "boogie";
      rev = "fc97aac639505f46cda7904dae95c9557716d037";
      sha256 = "1hjksc5sapw1shxjwg0swja5afman8i15wnv5b6rzkqd4mg8y6nz";
    };

    # emulate `nuget restore Source/Boogie.sln`
    # which installs in $srcdir/Source/packages
    preBuild = ''
      mkdir -p Source/packages/NUnit.2.6.3
      ln -sn ${dotnetPackages.NUnit}/lib/dotnet/NUnit Source/packages/NUnit.2.6.3/lib
    '';

    buildInputs = [
      dotnetPackages.NUnit
      dotnetPackages.NUnitRunners
    ];

    xBuildFiles = [ "Source/Boogie.sln" ];

    outputFiles = [ "Binaries/*" ];

    postInstall = ''
        mkdir -pv "$out/lib/dotnet/${baseName}"
        ln -sv "${pkgs.z3}/bin/z3" "$out/lib/dotnet/${baseName}/z3.exe"

        # so that this derivation can be used as a vim plugin to install syntax highlighting
        vimdir=$out/share/vim-plugins/boogie
        install -Dt $vimdir/syntax/ Util/vim/syntax/boogie.vim
        mkdir $vimdir/ftdetect
        echo 'au BufRead,BufNewFile *.bpl set filetype=boogie' > $vimdir/ftdetect/bpl.vim
    '';

    meta = with stdenv.lib; {
      description = "An intermediate verification language";
      homepage = "https://github.com/boogie-org/boogie";
      longDescription = ''
        Boogie is an intermediate verification language (IVL), intended as a
        layer on which to build program verifiers for other languages.

        This derivation may be used as a vim plugin to provide syntax highlighting.
      '';
      license = licenses.mspl;
      maintainers = [ maintainers.taktoa ];
      platforms = with platforms; (linux ++ darwin);
    };
  };

  Dafny = buildDotnetPackage rec {
    baseName = "Dafny";
    version = "2.1.0";

    src = fetchurl {
      url = "https://github.com/Microsoft/dafny/archive/v${version}.tar.gz";
      sha256 = "1iyhy0zpi6wvqif7826anzgdipgsy5bk775ds9qqwfw27j7x6fy5";
    };

    postPatch = ''
      sed -i \
        -e 's/ Visible="False"//' \
        -e "s/Exists(\$(CodeContractsInstallDir))/Exists('\$(CodeContractsInstallDir)')/" \
        Source/*/*.csproj
    '';

    preBuild = ''
      ln -s ${pkgs.z3} Binaries/z3
    '';

    buildInputs = [ Boogie ];

    xBuildFiles = [ "Source/Dafny.sln" ];
    xBuildFlags = [ "/p:Configuration=Checked" "/p:Platform=Any CPU" "/t:Rebuild" ];

    outputFiles = [ "Binaries/*" ];

    # Do not wrap the z3 executable, only dafny-related ones.
    exeFiles = [ "Dafny*.exe" ];

    # Dafny needs mono in its path.
    makeWrapperArgs = "--set PATH ${mono}/bin";

    # Boogie as an input is not enough. Boogie libraries need to be at the same
    # place as Dafny ones. Same for "*.dll.mdb". No idea why or how to fix.
    postFixup = ''
      for lib in ${Boogie}/lib/dotnet/${Boogie.baseName}/*.dll{,.mdb}; do
        ln -s $lib $out/lib/dotnet/${baseName}/
      done
      # We generate our own executable scripts
      rm -f $out/lib/dotnet/${baseName}/dafny{,-server}
    '';

    meta = with stdenv.lib; {
      description = "A programming language with built-in specification constructs";
      homepage = "http://research.microsoft.com/dafny";
      maintainers = with maintainers; [ layus ];
      license = licenses.mit;
      platforms = with platforms; (linux ++ darwin);
    };
  };

  Deedle = fetchNuGet rec {
    baseName = "Deedle";
    version = "1.2.5";
    sha256 = "0g19ll6bp97ixprcnpwwvshr1n9jxxf9xjhkxp0r63mg46z48jnw";
    outputFiles = [ "*" ];
  };

  ExcelDna = buildDotnetPackage rec {
    baseName = "Excel-DNA";
    version = "0.32.0";

    src = fetchFromGitHub {
      owner = "Excel-DNA";
      repo = "ExcelDna";
      rev = "10a163843bcc2fb5517f6f3d499e18a8b64df511";
      sha256 = "1w2ag9na20ly0m2sic3nkgdc4qqyb4x4c9iv588ynpkgd1pjndrk";
    };

    buildInputs = [ ];

    preConfigure = ''
      rm -vf Distribution/*.dll Distribution/*.exe # Make sure we don't use those
      substituteInPlace Source/ExcelDna.Integration/ExcelDna.Integration.csproj --replace LogDisplay.designer.cs LogDisplay.Designer.cs
    '';

    xBuildFiles = [ "Source/ExcelDna.sln" ];
    outputFiles = [ "Source/ExcelDnaPack/bin/Release/*" "Distribution/ExcelDna.xll" "Distribution/ExcelDna64.xll" ];

    meta = {
      description = "Excel-DNA is an independent project to integrate .NET into Excel";
      homepage = "https://excel-dna.net/";
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  ExcelDnaRegistration = buildDotnetPackage rec {
    baseName = "Excel-DNA.Registration";
    version = "git-" + (builtins.substring 0 10 rev);
    rev = "69abb1b3528f40dbcf425e13690aaeab5f707bb6";

    src = fetchFromGitHub {
      inherit rev;
      owner = "Excel-DNA";
      repo = "Registration";
      sha256 = "094932h6r2f4x9r5mnw8rm4jzz8vkfv90d95qi3h0i89ws2dnn07";
    };

    buildInputs = [
      fsharp
      dotnetPackages.ExcelDna
    ];

    xBuildFiles = [ "Source/ExcelDna.Registration/ExcelDna.Registration.csproj" "Source/ExcelDna.Registration.FSharp/ExcelDna.Registration.FSharp.fsproj" ];
    outputFiles = [ "Source/ExcelDna.Registration/bin/Release/*" "Source/ExcelDna.Registration.FSharp/bin/Release/*FSharp*" ];

    meta = {
      description = "This library implements helper functions to assist and modify the Excel-DNA function registration";
      homepage = "https://github.com/Excel-DNA/Registration";
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
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
    version = "0.18.2";

    src = fetchFromGitHub {
      owner = "fsharp";
      repo = "FSharp.AutoComplete";
      rev = version;
      sha256 = "1ikl72003xzqq2dc8i6h404hnq3q5g1p1q4rmzz9bdm7282q2jgs";
    };

    buildInputs = [
      fsharp
      dotnetPackages.FSharpCompilerService
      dotnetPackages.NewtonsoftJson
      dotnetPackages.NDeskOptions
    ];

    outputFiles = [ "FSharp.AutoComplete/bin/Release/*" ];

    meta = {
      description = "An interface to the FSharp.Compiler.Service project";
      longDescription = ''
        This project provides a command-line interface to the
        FSharp.Compiler.Service project. It is intended to be used as a backend
        service for rich editing or 'intellisense' features for editors.
        '';
      homepage = https://github.com/fsharp/FSharp.AutoComplete;
      license = stdenv.lib.licenses.asl20;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  FSharpCompilerService = buildDotnetPackage rec {
    baseName = "FSharp.Compiler.Service";
    version = "0.0.90";

    src = fetchFromGitHub {
      owner = "fsharp";
      repo = "FSharp.Compiler.Service";
      rev = "a87939ab3f3c571cad79bc3b5f298aa3e180e6b3";
      sha256 = "0axr38q8m0h11hhbxg5myd1wwfgysadriln8c7bqsv5sf9djihvd";
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
    version = "2.2.3";

    src = fetchFromGitHub {
      owner = "fsharp";
      repo = baseName;
      rev = version;
      sha256 = "1h3v9rc8k0khp61cv5n01larqbxd3xcx3q52sw5zf9l0661vw7qr";
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
  #     description = "FSharpx.Extras is a collection of libraries and tools for use with F#";
  #     homepage = "http://fsprojects.github.io/FSharpx.Extras/";
  #     license = stdenv.lib.licenses.asl20;
  #     maintainers = with stdenv.lib.maintainers; [ obadz ];
  #     platforms = with stdenv.lib.platforms; linux;
  #   };
  # };

  GitVersionTree = buildDotnetPackage rec {
    baseName = "GitVersionTree";
    version = "2013-10-01";

    src = fetchFromGitHub {
      owner = "crc8";
      repo = "GitVersionTree";
      rev = "58dc39c43cffea44f721ee4425835e56518f7da2";
      sha256 = "0mna5pkpqkdr5jgn8paz004h1pa24ncsvmi2c8s4gp94nfw34x05";
    };

    buildInputs = with pkgs; [ ed ];

    postPatch = ''
      ed -v -p: -s GitVersionTree/Program.cs << EOF
      /Main()
      c
      static void Main(string[] args)
      .
      /EnableVisualStyles
      i
      Reg.Write("GitPath", "${pkgs.gitMinimal}/bin/git");
      Reg.Write("GraphvizPath", "${pkgs.graphviz}/bin/dot");
      if (args.Length > 0) {
        Reg.Write("GitRepositoryPath", args[0]);
      }
      .
      w
      EOF

      substituteInPlace GitVersionTree/Forms/MainForm.cs \
        --replace 'Directory.GetParent(Application.ExecutablePath)' 'Environment.CurrentDirectory' \
        --replace '\\' '/' \
        --replace '@"\"' '"/"'
    '';

    outputFiles = [ "GitVersionTree/bin/Release/*" ];
    exeFiles = [ "GitVersionTree.exe" ];

    meta = with stdenv.lib; {
      description = "A tool to help visualize git revisions and branches";
      homepage = https://github.com/crc8/GitVersionTree;
      license = licenses.gpl2;
      maintainers = with maintainers; [ obadz ];
      platforms = platforms.all;
    };
  };

  MathNetNumerics = buildDotnetPackage rec {
    baseName = "MathNet.Numerics";
    version = "3.7.0";

    src = fetchurl {
      name = "${baseName}-${version}.tar.gz";
      url = "https://github.com/mathnet/mathnet-numerics/archive/v${version}.tar.gz";
      sha256 = "1yq6aqmc2gwh96z544qn83kby01lv1lsxm158hq0bimv2i9yywc7";
    };

    buildInputs = [ fsharp ];

    xBuildFiles = [ "MathNet.Numerics.sln" ];
    outputFiles = [ "out/lib/Net40/*" "src/FSharp/MathNet.Numerics.fsx" "src/FSharp/MathNet.Numerics.IfSharp.fsx" ];

    meta = {
      description = "Math.NET Numerics is an opensource numerical library for .Net, Silverlight and Mono";
      homepage = https://numerics.mathdotnet.com/;
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  MonoAddins = buildDotnetPackage rec {
    baseName = "Mono.Addins";
    version = "1.2";

    xBuildFiles = [
      "Mono.Addins/Mono.Addins.csproj"
      "Mono.Addins.Setup/Mono.Addins.Setup.csproj"
      "Mono.Addins.Gui/Mono.Addins.Gui.csproj"
      "Mono.Addins.CecilReflector/Mono.Addins.CecilReflector.csproj"
    ];
    outputFiles = [ "bin/*" ];

    src = fetchFromGitHub {
      owner = "mono";
      repo = "mono-addins";
      rev = "mono-addins-${version}";
      sha256 = "1hnn0a2qsjcjprsxas424bzvhsdwy0yc2jj5xbp698c0m9kfk24y";
    };

    buildInputs = [ pkgs.gtk-sharp-2_0 ];

    meta = {
      description = "A generic framework for creating extensible applications";
      homepage = http://www.mono-project.com/Mono.Addins;
      longDescription = ''
        A generic framework for creating extensible applications,
        and for creating libraries which extend those applications.
      '';
      license = stdenv.lib.licenses.mit;
    };
  };

  # MonoDevelopFSharpBinding = buildDotnetPackage rec {
  #   baseName = "MonoDevelop.FSharpBinding";
  #   version = "git-a09c8185eb";

  #   broken = true;

  #   src = fetchFromGitHub {
  #     owner = "fsharp";
  #     repo = "fsharpbinding";
  #     rev = "a09c8185ebf23fe2f7d22b14b4af2e3268d4f011";
  #     sha256 = "1zp5gig42s1h681kch0rw5ykbbj0mcsmdvpyz1319wy9s7n2ng91";
  #   };

  #   buildInputs = [
  #     fsharp
  #     monodevelop
  #     pkgs.gtk-sharp
  #     pkgs.gnome-sharp
  #     dotnetPackages.ExtCore
  #     dotnetPackages.FSharpCompilerService
  #     dotnetPackages.FSharpCompilerCodeDom
  #     dotnetPackages.FSharpAutoComplete
  #     dotnetPackages.Fantomas
  #   ];

  #   patches = [
  #     ../development/dotnet-modules/patches/monodevelop-fsharpbinding.references.patch
  #     ../development/dotnet-modules/patches/monodevelop-fsharpbinding.addin-xml.patch
  #   ];

  #   preConfigure = ''
  #     substituteInPlace monodevelop/configure.fsx --replace /usr/lib/monodevelop ${monodevelop}/lib/monodevelop
  #     substituteInPlace monodevelop/configure.fsx --replace bin/MonoDevelop.exe ../../bin/monodevelop
  #     (cd monodevelop; fsharpi ./configure.fsx)
  #   '';

  #   # This will not work as monodevelop probably looks in absolute nix store path rather than path
  #   # relative to its executable. Need to ln -s /run/current-system/sw/lib/dotnet/MonoDevelop.FSharpBinding
  #   # ~/.local/share/MonoDevelop-5.0/LocalInstall/Addins/ to install until we have a better way

  #   # postInstall = ''
  #   #   mkdir -p "$out/lib/monodevelop/AddIns"
  #   #   ln -sv "$out/lib/dotnet/${baseName}" "$out/lib/monodevelop/AddIns"
  #   # '';

  #   xBuildFiles = [ "monodevelop/MonoDevelop.FSharpBinding/MonoDevelop.FSharp.mac-linux.fsproj" ];
  #   outputFiles = [ "monodevelop/bin/mac-linux/Release/*" ];

  #   meta = {
  #     description = "F# addin for MonoDevelop 5.9";
  #     homepage = "https://github.com/fsharp/fsharpbinding/tree/5.9";
  #     license = stdenv.lib.licenses.asl20;
  #     maintainers = with stdenv.lib.maintainers; [ obadz ];
  #     platforms = with stdenv.lib.platforms; linux;
  #   };
  # };

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

    postInstall = ''
      # Otherwise pkg-config won't find it and the DLL will get duplicated
      ln -sv $out/lib/pkgconfig/ndesk-options.pc $out/lib/pkgconfig/NDesk.Options.pc
    '';

    dontStrip = true;

    meta = {
      description = "A callback-based program option parser for C#";
      homepage = http://www.ndesk.org/Options;
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

  NewtonsoftJson = fetchNuGet {
    baseName = "Newtonsoft.Json";
    version = "11.0.2";
    sha256 = "07na27n4mlw77f3hg5jpayzxll7f4gyna6x7k9cybmxpbs6l77k7";
    outputFiles = [ "*" ];
  };

  Nuget = buildDotnetPackage {
    baseName = "Nuget";
    version = "3.4.3";

    src = fetchFromGitHub {
      owner = "mono";
      repo = "nuget-binary";
      rev = "1f3025c2eb13bfcb56b47ddd77329ac3d9911d1c";
      sha256 = "01snk05hcrp5i2ys3p1y34r05q1b460q6wb8p3vwpba2q2czdax5";
    };

    buildInputs = [ unzip ];

    phases = [ "unpackPhase" "installPhase" ];

    outputFiles = [ "*" ];
    dllFiles = [ "NuGet*.dll" ];
    exeFiles = [ "nuget.exe" ];
  };

  Paket = fetchNuGet {
    baseName = "Paket";
    version = "5.179.1";
    sha256 = "11rzna03i145qj08hwrynya548fwk8xzxmg65swyaf19jd7gzg82";
    outputFiles = [ "*" ];
  };

  Projekt = buildDotnetPackage rec {
    baseName = "projekt";
    version = "git-" + (builtins.substring 0 10 rev);
    rev = "715a21e5cd3c86310387562618b04e979d0ec9c4";

    src = fetchFromGitHub {
      inherit rev;
      owner = "kjnilsson";
      repo = "projekt";
      sha256 = "1ph3af07wmia6qkiq1qlywaj2xh6zn5drdx19dwb1g3237h5fnz0";
    };

    buildInputs = [
      fsharp
      dotnetPackages.UnionArgParser
      dotnetPackages.FsUnit
    ];

    preConfigure = ''
      sed -i -e "s/FSharp.Core, Version=\$(TargetFSharpCoreVersion), Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a/FSharp.Core/" src/Projekt/Projekt.fsproj
    '';

    outputFiles = [ "src/Projekt/bin/Release/*" ];

    meta = {
      description = "A command-line tool for manipulating F# project files";
      homepage = "https://github.com/kjnilsson/projekt";
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
      description = "A declarative CLI argument/XML configuration parser for F# applications";
      homepage = http://nessos.github.io/UnionArgParser/;
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ obadz ];
      platforms = with stdenv.lib.platforms; linux;
    };
  };

}; in self
