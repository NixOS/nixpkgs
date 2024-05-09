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
, boogie
, nuget
}:

let self = dotnetPackages // overrides; dotnetPackages = with self; {
  # ALIASES FOR MOVED PACKAGES

  Boogie = boogie;
  Nuget = nuget;

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
    meta.mainProgram = "stylecopsettingseditor";
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

  Paket = fetchNuGet {
    pname = "Paket";
    version = "5.179.1";
    sha256 = "11rzna03i145qj08hwrynya548fwk8xzxmg65swyaf19jd7gzg82";
    outputFiles = [ "*" ];
  };

}; in self
