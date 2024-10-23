{ config
, elk7Version
, elk8Version
, enableUnfree ? true
, lib
, stdenv
, fetchurl
, makeWrapper
, nixosTests
, jre
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes = {
    "7.17.16" = if enableUnfree
      then {
        x86_64-linux  = "sha512-ze0hJxUHCN52bOxUs5upDj64tIE58P2BTow2kaCo6HreRiF9rfTTzNkNr/hCmEgE+/oFbgSEuOQLz+6G373RDQ==";
        x86_64-darwin = "sha512-FOFd8d+4UddSGorjuUWW/JbQ5fQH4LU1f1HJLmdbfnb8Q5L4GEveb2LmWNILU8/a85V4HGmD6lL8mCJqH9CULQ==";
        aarch64-linux = "sha512-giYqW88/6iT3haXzJVn/+b7uxjYhHq4GERmiq3tMIvjxDyu7B6g+X7JneaTYxhpNdn6gOD/hfXgNv+hFRq6lgg==";
      }
      else {
        x86_64-linux  = "sha512-OC9gx76k+RMdjqcDkrJCNbPYSQameyddaYMxUIB0foVxCmo6UvbdcwZGXRLPPn95in8rYOCjvPoBkmupiQw9xQ==";
        x86_64-darwin = "sha512-1OEfEED/jjlT3Fd095Y5VYiWKnovytI3UYCCy1Rs3tEvkZPHYwqIQHfMQYeAvGgUci37ADwEDu8xrSQULHToLw==";
        aarch64-linux = "sha512-QWW0AXOMNIXThxpUiRomvINm+917MvGrSDndrEw11IYYuvi0d0dckJiRytfnBbBNoOKpVhB68uOmfjIcZBNpWQ==";
      };
    "8.14.1" = if enableUnfree
      then {
        x86_64-linux  = "sha512-psuE1o0Fo26UyfKsYdCUdaZx+oebwxQfd0sGg0BWJPsb8+zvzar6SYzLwI2uB3ZOchXh4jFJAWtYI0zE5WC7nw==";
        x86_64-darwin = "sha512-5sPRzCpwOYW4nhykgFvYS1S/ghLCHS+BxMpUytODE1xec1TyRb+LWQYuluY133apf9aO61rhW1bcV1khbiAMyg==";
        aarch64-linux = "sha512-STDq62/biZSd5tgqLGZlNlV8FbC60UuP3FGRDX5g9UFvG0BsZUY/H0vPrU7+ARpzn78jdp1gBTmGtJpdWY7I7g==";
      }
      else {
        x86_64-linux  = "sha512-rinfcD1xWrwApanlM4mZdFqAp47tihMvq1WRWHpep08ZdLoXrPppclYSsVqGLcaY0NABuMpzu9gGnIfbRZtiXQ==";
        x86_64-darwin = "sha512-+U9gBsKZHwul3pl9FvRr+H1gmZp8xT1grj8+oH+cI9g69f5bHmNA41cejRCexEUkNpth3ttN28vIGhtWZPB5QQ==";
        aarch64-linux = "sha512-qzGrLmFHS5PIYns28HcSqClnmySiy80E5DnY/s7MQUE8bDMho1Z4uc1nzdulNHEtleW1HcbSCnGo3qTb2J4pqA==";
      };
  };
  logstash = elkVersion: extraAttrs: stdenv.mkDerivation rec {
    version = elkVersion;
    pname = "logstash${lib.optionalString (!enableUnfree) "-oss"}";


    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/logstash/${pname}-${version}-${plat}-${arch}.tar.gz";
      hash = hashes."${version}".${stdenv.hostPlatform.system} or (throw "Unknown architecture");
    };

    dontBuild = true;
    dontPatchELF = true;
    dontStrip = true;
    dontPatchShebangs = true;

    nativeBuildInputs = [
      makeWrapper
    ];

    buildInputs = [
      jre
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r {Gemfile*,modules,vendor,lib,bin,config,data,logstash-core,logstash-core-plugin-api} $out

      patchShebangs $out/bin/logstash
      patchShebangs $out/bin/logstash-plugin

      wrapProgram $out/bin/logstash \
         --set LS_JAVA_HOME "${jre}"

      wrapProgram $out/bin/logstash-plugin \
         --set LS_JAVA_HOME "${jre}"
      runHook postInstall
    '';

    meta = with lib; {
      description = "Logstash is a data pipeline that helps you process logs and other event data from a variety of systems";
      homepage = "https://www.elastic.co/products/logstash";
      sourceProvenance = with sourceTypes; [
        fromSource
        binaryBytecode  # source bundles dependencies as jars
        binaryNativeCode  # bundled jruby includes native code
      ];
      license = if enableUnfree then licenses.elastic20 else licenses.asl20;
      platforms = platforms.unix;
      maintainers = with maintainers; [ offline basvandijk ];
    };
  } // extraAttrs;
in rec {
  logstash7 = logstash elk7Version {
     passthru.tests =
      lib.optionalAttrs (config.allowUnfree && enableUnfree) (
        assert logstash7.drvPath == nixosTests.elk.unfree.ELK-7.elkPackages.logstash.drvPath;
        {
          elk = nixosTests.elk.unfree.ELK-7;
        }
      );
  };
  logstash8 = logstash elk8Version {
    passthru.tests =
      lib.optionalAttrs (config.allowUnfree && enableUnfree) (
        assert logstash7.drvPath == nixosTests.elk.unfree.ELK-8.elkPackages.logstash.drvPath;
        {
          elk = nixosTests.elk.unfree.ELK-8;
        }
      );
  };
}
