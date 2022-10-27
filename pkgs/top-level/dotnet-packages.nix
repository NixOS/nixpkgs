{ stdenv
, lib
, pkgs
, buildDotnetPackage
, buildDotnetModule
, fetchurl
, fetchFromGitHub
, fetchNuGet
, glib
, mono
, overrides ? {}
}:

let self = dotnetPackages // overrides; dotnetPackages = with self; {

  # BINARY PACKAGES

  NUnit3 = fetchNuGet {
    pname = "NUnit";
    version = "3.0.1";
    sha256 = "1g3j3kvg9vrapb1vjgq65nvn1vg7bzm66w7yjnaip1iww1yn1b0p";
    outputFiles = [ "lib/*" ];
  };

  NUnit2 = fetchNuGet {
    pname = "NUnit";
    version = "2.6.4";
    sha256 = "1acwsm7p93b1hzfb83ia33145x0w6fvdsfjm9xflsisljxpdx35y";
    outputFiles = [ "lib/*" ];
  };

  NUnit = NUnit2;

  NUnitConsole = fetchNuGet {
    pname = "NUnit.Console";
    version = "3.0.1";
    sha256 = "154bqwm2n95syv8nwd67qh8qsv0b0h5zap60sk64z3kd3a9ffi5p";
    outputFiles = [ "tools/*" ];
  };

  MaxMindDb = fetchNuGet {
    pname = "MaxMind.Db";
    version = "1.1.0.0";
    sha256 = "0lixl76f7k3ldiqzg94zh13gn82w5mm5dx72y97fcqvp8g6nj3ds";
    outputFiles = [ "lib/*" ];
  };

  MaxMindGeoIP2 = fetchNuGet {
    pname = "MaxMind.GeoIP2";
    version = "2.3.1";
    sha256 = "1s44dvjnmj1aimbrgkmpj6h5dn1w6acgqjch1axc76yz6hwknqgf";
    outputFiles = [ "lib/*" ];
  };

  SharpZipLib = fetchNuGet {
    pname = "SharpZipLib";
    version = "1.3.3";
    sha256 = "sha256-HWEQTKh9Ktwg/zIl079dAiH+ob2ShWFAqLgG6XgIMr4=";
    outputFiles = [ "lib/*" ];
  };

  StyleCopMSBuild = fetchNuGet {
    pname = "StyleCop.MSBuild";
    version = "4.7.49.0";
    sha256 = "0rpfyvcggm881ynvgr17kbx5hvj7ivlms0bmskmb2zyjlpddx036";
    outputFiles = [ "tools/*" ];
  };

  StyleCopPlusMSBuild = fetchNuGet {
    pname = "StyleCopPlus.MSBuild";
    version = "4.7.49.5";
    sha256 = "1hv4lfxw72aql8siyqc4n954vzdz8p6jx9f2wrgzz0jy1k98x2mr";
    outputFiles = [ "tools/*" ];
  };

  RestSharp = fetchNuGet {
    pname = "RestSharp";
    version = "106.12.0";
    sha256 = "sha256-NGzveByJvCRtHlI2C8d/mLs3akyMm77NER8TUG6HiD4=";
    outputFiles = [ "lib/*" ];
  };

  SharpFont = fetchNuGet {
    pname = "SharpFont";
    version = "4.0.1";
    sha256 = "1yd3cm4ww0hw2k3aymf792hp6skyg8qn491m2a3fhkzvsl8z7vs8";
    outputFiles = [ "lib/*" "config/*" ];
  };

  SmartIrc4net = fetchNuGet {
    pname = "SmartIrc4net";
    version = "0.4.5.1";
    sha256 = "1d531sj39fvwmj2wgplqfify301y3cwp7kwr9ai5hgrq81jmjn2b";
    outputFiles = [ "lib/*" ];
  };

  FuzzyLogicLibrary = fetchNuGet {
    pname = "FuzzyLogicLibrary";
    version = "1.2.0";
    sha256 = "0x518i8d3rw9n51xwawa4sywvqd722adj7kpcgcm63r66s950r5l";
    outputFiles = [ "bin/*" ];
  };

  OpenNAT = fetchNuGet {
    pname = "Open.NAT";
    version = "2.1.0";
    sha256 = "1jyd30fwycdwx5ck96zhp2xf20yz0sp7g3pjbqhmay4kd322mfwk";
    outputFiles = [ "lib/*" ];
  };

  MonoNat = fetchNuGet {
    pname = "Mono.Nat";
    version = "1.2.24";
    sha256 = "0vfkach11kkcd9rcqz3s38m70d5spyb21gl99iqnkljxj5555wjs";
    outputFiles = [ "lib/*" ];
  };

  NUnitRunners = fetchNuGet {
    pname = "NUnit.Runners";
    version = "2.6.4";
    sha256 = "11nmi7vikn9idz8qcad9z7f73arsh5rw18fc1sri9ywz77mpm1s4";
    outputFiles = [ "tools/*" ];
    preInstall = "mv -v tools/lib/* tools && rmdir -v tools/lib";
  };

  # SOURCE PACKAGES

  Boogie = buildDotnetModule rec {
    pname = "Boogie";
    version = "2.15.7";

    src = fetchFromGitHub {
      owner = "boogie-org";
      repo = "boogie";
      rev = "v${version}";
      sha256 = "16kdvkbx2zwj7m43cra12vhczbpj23wyrdnj0ygxf7np7c2aassp";
    };

    projectFile = [ "Source/Boogie.sln" ];
    nugetDeps = ../development/dotnet-modules/boogie-deps.nix;

    postInstall = ''
        mkdir -pv "$out/lib/dotnet/${pname}"
        ln -sv "${pkgs.z3}/bin/z3" "$out/lib/dotnet/${pname}/z3.exe"

        # so that this derivation can be used as a vim plugin to install syntax highlighting
        vimdir=$out/share/vim-plugins/boogie
        install -Dt $vimdir/syntax/ Util/vim/syntax/boogie.vim
        mkdir $vimdir/ftdetect
        echo 'au BufRead,BufNewFile *.bpl set filetype=boogie' > $vimdir/ftdetect/bpl.vim
    '';

    postFixup = ''
        ln -s "$out/bin/BoogieDriver" "$out/bin/boogie"
    '';

    meta = with lib; {
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

  Boogie_2_4_1 = buildDotnetPackage rec {
    pname = "Boogie";
    version = "2.4.1";

    src = fetchFromGitHub {
      owner = "boogie-org";
      repo = "boogie";
      rev = "v${version}";
      sha256 = "13f6ifkh6gpy4bvx5zhgwmk3wd5rfxzl9wxwfhcj1c90fdrhwh1b";
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
        mkdir -pv "$out/lib/dotnet/${pname}"
        ln -sv "${pkgs.z3}/bin/z3" "$out/lib/dotnet/${pname}/z3.exe"

        # so that this derivation can be used as a vim plugin to install syntax highlighting
        vimdir=$out/share/vim-plugins/boogie
        install -Dt $vimdir/syntax/ Util/vim/syntax/boogie.vim
        mkdir $vimdir/ftdetect
        echo 'au BufRead,BufNewFile *.bpl set filetype=boogie' > $vimdir/ftdetect/bpl.vim
    '';

    meta = with lib; {
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

  Dafny = let
    z3 = pkgs.z3.overrideAttrs (oldAttrs: rec {
      version = "4.8.4";
      name = "z3-${version}";

      src = fetchFromGitHub {
        owner = "Z3Prover";
        repo = "z3";
        rev = "z3-${version}";
        sha256 = "014igqm5vwswz0yhz0cdxsj3a6dh7i79hvhgc3jmmmz3z0xm1gyn";
      };
    });
    self' = pkgs.dotnetPackages.override ({
      pkgs = pkgs // { inherit z3; };
    });
    Boogie = assert self'.Boogie_2_4_1.version == "2.4.1"; self'.Boogie_2_4_1;
  in buildDotnetPackage rec {
    pname = "Dafny";
    version = "2.3.0";

    src = fetchurl {
      url = "https://github.com/Microsoft/dafny/archive/v${version}.tar.gz";
      sha256 = "0s6ihx32kda7400lvdrq60l46c11nki8b6kalir2g4ic508f6ypa";
    };

    postPatch = ''
      sed -i \
        -e 's/ Visible="False"//' \
        -e "s/Exists(\$(CodeContractsInstallDir))/Exists('\$(CodeContractsInstallDir)')/" \
        Source/*/*.csproj
    '';

    preBuild = ''
      ln -s ${z3} Binaries/z3
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
      for lib in ${Boogie}/lib/dotnet/${Boogie.pname}/*.dll{,.mdb}; do
        ln -s $lib $out/lib/dotnet/${pname}/
      done
      # We generate our own executable scripts
      rm -f $out/lib/dotnet/${pname}/dafny{,-server}
    '';

    meta = with lib; {
      description = "A programming language with built-in specification constructs";
      homepage = "https://research.microsoft.com/dafny";
      maintainers = with maintainers; [ layus ];
      license = licenses.mit;
      platforms = with platforms; (linux ++ darwin);
    };
  };

  MonoAddins = buildDotnetPackage rec {
    pname = "Mono.Addins";
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
      homepage = "https://www.mono-project.com/Mono.Addins";
      longDescription = ''
        A generic framework for creating extensible applications,
        and for creating libraries which extend those applications.
      '';
      license = lib.licenses.mit;
    };
  };

  NewtonsoftJson = fetchNuGet {
    pname = "Newtonsoft.Json";
    version = "11.0.2";
    sha256 = "07na27n4mlw77f3hg5jpayzxll7f4gyna6x7k9cybmxpbs6l77k7";
    outputFiles = [ "*" ];
  };

  Nuget = buildDotnetPackage rec {
    pname = "Nuget";
    version = "5.6.0.6489";

    src = fetchFromGitHub {
      owner = "mono";
      repo = "linux-packaging-nuget";
      rev = "upstream/${version}.bin";
      sha256 = "sha256-71vjM7a+F0DNTY+dML3UBSkrVyXv/k5rdl7iXBKSpNM=";
    };

    # configurePhase breaks the binary and results in
    # `File does not contain a valid CIL image.`
    dontConfigure = true;
    dontBuild = true;
    dontPlacateNuget = true;

    outputFiles = [ "*" ];
    exeFiles = [ "nuget.exe" ];
  };

  Paket = fetchNuGet {
    pname = "Paket";
    version = "5.179.1";
    sha256 = "11rzna03i145qj08hwrynya548fwk8xzxmg65swyaf19jd7gzg82";
    outputFiles = [ "*" ];
  };

}; in self
