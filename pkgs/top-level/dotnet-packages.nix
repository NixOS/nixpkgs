{ stdenv
, lib
, pkgs
, buildDotnetPackage
, fetchurl
, fetchFromGitHub
, fetchNuGet
, glib
, pkg-config
, mono
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
    version = "4.3.1";
    sha256 = "0qzq878s66yfkf4n2b9af8lw2bx45s3cg6mi0w8w0bi358fa7q70";
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
    version = "4.0.1";
    sha256 = "1yd3cm4ww0hw2k3aymf792hp6skyg8qn491m2a3fhkzvsl8z7vs8";
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
  # SOURCE PACKAGES

  Boogie = buildDotnetPackage rec {
    baseName = "Boogie";
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
        mkdir -pv "$out/lib/dotnet/${baseName}"
        ln -sv "${pkgs.z3}/bin/z3" "$out/lib/dotnet/${baseName}/z3.exe"

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
    Boogie = assert self'.Boogie.version == "2.4.1"; self'.Boogie;
  in buildDotnetPackage rec {
    baseName = "Dafny";
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
      for lib in ${Boogie}/lib/dotnet/${Boogie.baseName}/*.dll{,.mdb}; do
        ln -s $lib $out/lib/dotnet/${baseName}/
      done
      # We generate our own executable scripts
      rm -f $out/lib/dotnet/${baseName}/dafny{,-server}
    '';

    meta = with lib; {
      description = "A programming language with built-in specification constructs";
      homepage = "https://research.microsoft.com/dafny";
      maintainers = with maintainers; [ layus ];
      license = licenses.mit;
      platforms = with platforms; (linux ++ darwin);
    };
  };

  Deedle = fetchNuGet {
    baseName = "Deedle";
    version = "1.2.5";
    sha256 = "0g19ll6bp97ixprcnpwwvshr1n9jxxf9xjhkxp0r63mg46z48jnw";
    outputFiles = [ "*" ];
  };

  ExcelDna = buildDotnetPackage {
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
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ obadz ];
      platforms = with lib.platforms; linux;
    };
  };

  GitVersionTree = buildDotnetPackage {
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

    meta = with lib; {
      description = "A tool to help visualize git revisions and branches";
      homepage = "https://github.com/crc8/GitVersionTree";
      license = licenses.gpl2;
      maintainers = with maintainers; [ obadz ];
      platforms = platforms.all;
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
      homepage = "https://www.mono-project.com/Mono.Addins";
      longDescription = ''
        A generic framework for creating extensible applications,
        and for creating libraries which extend those applications.
      '';
      license = lib.licenses.mit;
    };
  };


  NDeskOptions = stdenv.mkDerivation rec {
    pname = "NDesk.Options";
    version = "0.2.1";

    src = fetchurl {
      name = "${pname}-${version}.tar.gz";
      url = "http://www.ndesk.org/archive/ndesk-options/ndesk-options-${version}.tar.gz";
      sha256 = "1y25bfapafwmifakjzyb9c70qqpvza8g5j2jpf08j8wwzkrb6r28";
    };

    buildInputs = [
      mono
      pkg-config
    ];

    postInstall = ''
      # Otherwise pkg-config won't find it and the DLL will get duplicated
      ln -sv $out/lib/pkgconfig/ndesk-options.pc $out/lib/pkgconfig/NDesk.Options.pc
    '';

    dontStrip = true;

    meta = {
      description = "A callback-based program option parser for C#";
      homepage = "http://www.ndesk.org/Options";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ obadz ];
      platforms = with lib.platforms; linux;
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
    version = "4.9.1";

    src = fetchFromGitHub {
      owner = "mono";
      repo = "nuget-binary";
      rev = "7871fa26914593fdb2f2500df1196df7b8aecb1c";
      sha256 = "07r63xam6icm17pf6amh1qkmna13nxa3ncdan7a3ql307i5isriz";
    };

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

  YamlDotNet = fetchNuGet {
    baseName = "YamlDotNet";
    version = "11.1.1";
    sha256 = "rwZ/QyDVrN3wGrEYKY3QY5Xqo2Tp3FkR6dh4QrC+QS0=";
    outputFiles = [ "lib/*" ];

    meta = with lib; {
      description = "YamlDotNet is a .NET library for YAML";
      homepage = "https://github.com/aaubry/YamlDotNet";
      license = licenses.mit;
      maintainers = [ maintainers.ratsclub ];
    };
  };

}; in self
