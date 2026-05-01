{
  stdenv,
  lib,
  pkgs,
  buildDotnetPackage,
  buildDotnetModule,
  fetchurl,
  fetchFromGitHub,
  fetchNuGet,
  glib,
  mono,
  overrides ? { },
  boogie,
  nuget,
}:

let
  self = dotnetPackages // overrides;
  dotnetPackages = with self; {
    # ALIASES FOR MOVED PACKAGES

    Boogie = boogie;
    Nuget = nuget;

    # BINARY PACKAGES

    NUnit3 = fetchNuGet {
      pname = "NUnit";
      version = "3.0.1";
      hash = "sha256-6wsVa0QUJiLXzVcwc9bckl+FKfKGBjcyX1r4X5TbQjw=";
      outputFiles = [ "lib/*" ];
    };

    NUnit2 = fetchNuGet {
      pname = "NUnit";
      version = "2.6.4";
      hash = "sha256-Kkft3QO9T5WwsvyPRNGT2nut7RS7OWArDjIYxvwA8qU=";
      outputFiles = [ "lib/*" ];
    };

    NUnit = NUnit2;

    NUnitConsole = fetchNuGet {
      pname = "NUnit.Console";
      version = "3.0.1";
      hash = "sha256-FkzpEk12msmUp5I05ZzlGiG+UInoYhBmar/vB5Gt4H8=";
      outputFiles = [ "tools/*" ];
    };

    MaxMindDb = fetchNuGet {
      pname = "MaxMind.Db";
      version = "1.1.0.0";
      hash = "sha256-q1t7EAlYavoR7Gl0Q63i1i08yv+6k0xki8lvjUFWNRE=";
      outputFiles = [ "lib/*" ];
    };

    MaxMindGeoIP2 = fetchNuGet {
      pname = "MaxMind.GeoIP2";
      version = "2.3.1";
      hash = "sha256-InhgU9iugwGzVm0+V89KlGTen9hbAvEI8Fg1ZZgvthM=";
      outputFiles = [ "lib/*" ];
    };

    SharpZipLib = fetchNuGet {
      pname = "SharpZipLib";
      version = "1.3.3";
      hash = "sha256-HWEQTKh9Ktwg/zIl079dAiH+ob2ShWFAqLgG6XgIMr4=";
      outputFiles = [ "lib/*" ];
    };

    StyleCopMSBuild = fetchNuGet {
      pname = "StyleCop.MSBuild";
      version = "4.7.49.0";
      hash = "sha256-jXx62X50DwiZYYa/wzzZlbXWuZ7z7TIybkDGcUjWULI=";
      outputFiles = [ "tools/*" ];
      meta.mainProgram = "stylecopsettingseditor";
    };

    StyleCopPlusMSBuild = fetchNuGet {
      pname = "StyleCopPlus.MSBuild";
      version = "4.7.49.5";
      hash = "sha256-yYIlp0RYaQe+12ekyyp1b/Oo0T/zVbQOzEPD4lN2g9k=";
      outputFiles = [ "tools/*" ];
    };

    RestSharp = fetchNuGet {
      pname = "RestSharp";
      version = "106.12.0";
      hash = "sha256-NGzveByJvCRtHlI2C8d/mLs3akyMm77NER8TUG6HiD4=";
      outputFiles = [ "lib/*" ];
    };

    SharpFont = fetchNuGet {
      pname = "SharpFont";
      version = "4.0.1";
      hash = "sha256-uzgXAi9zBKDNk9fzrLQFeF9RuEgc4cNUMoA/LEX//T4=";
      outputFiles = [
        "lib/*"
        "config/*"
      ];
    };

    SmartIrc4net = fetchNuGet {
      pname = "SmartIrc4net";
      version = "0.4.5.1";
      hash = "sha256-NtZhVjY5HPzi6wyAunZiFHGs1PU0rNH9/Ob+zWpAhI8=";
      outputFiles = [ "lib/*" ];
    };

    FuzzyLogicLibrary = fetchNuGet {
      pname = "FuzzyLogicLibrary";
      version = "1.2.0";
      hash = "sha256-yoyvM2N65mHf3VeXWJ8DSVDS/LT3GS7oWIMPbiUl3z8=";
      outputFiles = [ "bin/*" ];
    };

    OpenNAT = fetchNuGet {
      pname = "Open.NAT";
      version = "2.1.0";
      hash = "sha256-xTLe4UeLSn4oqkeXpe/D+CmmvQzAr2RqrAAc4YPw4+I=";
      outputFiles = [ "lib/*" ];
    };

    MonoNat = fetchNuGet {
      pname = "Mono.Nat";
      version = "1.2.24";
      hash = "sha256-Ydr8esuvKPm6y+dHSuUXq2Wsg2VjuL/hhE+yGSr3dZg=";
      outputFiles = [ "lib/*" ];
    };

    NUnitRunners = fetchNuGet {
      pname = "NUnit.Runners";
      version = "2.6.4";
      hash = "sha256-yXWs50zuGAtWmtUkxRGNJXCBUQhWoLzSRpyy5NmHepo=";
      outputFiles = [ "tools/*" ];
      preInstall = "mv -v tools/lib/* tools && rmdir -v tools/lib";
    };

    # SOURCE PACKAGES

    NewtonsoftJson = fetchNuGet {
      pname = "Newtonsoft.Json";
      version = "11.0.2";
      hash = "sha256-YhlAbGfwoxQzxb3Hef4iyV9eGdPQJJNd2GgSR0jsBJ0=";
      outputFiles = [ "*" ];
      postInstall = "rm $target/env-vars"; # fetchNuGet already sets preInstall
    };

    Paket = fetchNuGet {
      pname = "Paket";
      version = "5.179.1";
      hash = "sha256-Ar3/TpMpOOW5LubV/jua3CFSlLc+c4iAxIWEOICyP4c=";
      outputFiles = [ "*" ];
      postInstall = "rm $target/env-vars"; # fetchNuGet already sets preInstall
    };

  };
in
self
