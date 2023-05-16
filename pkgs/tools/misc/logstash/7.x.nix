{ config
, elk7Version
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
  shas =
    if enableUnfree
    then {
<<<<<<< HEAD
      x86_64-linux  = "5391bfef09c403a365518a3a8e8f075bb7974b137095b3c7fd2a0173cfa6dbd4a7451170a3657afef3e6a468e90a38d6e7a5b669799878f9389fa44ff8fee026";
      x86_64-darwin = "8e3516b82329a47505358fb7eab486ca39423adc44a1f061c35f6ba225ac2f37330f2afc3e37eb652b6536e5ca35d77ac2485dec743fa8d99dd4fcc60bddbc21";
      aarch64-linux = "06f91a5aabff0f86a4150de6c1fd02fb6d0a44b04ac660597cb4c8356cf1d22552aaa77899db42a49a5e35b3cad73be5d7bad8cacfb4b17e622949329cdf791a";
    }
    else {
      x86_64-linux  = "ba22c4c414f47515387bb28cc47612bea58aff97c407f2571863e83174a2bef273627f65dd531ed833e40668c79144a501d49c3ec691c1b1c4d8fb0cb124b052";
      x86_64-darwin = "81a97ca06c086fac33f32e90124f649d5ddce09d649021020f434b75b5bff63065f9dc8aa267b72cedd581089bc24db12122f705ef8b69acf8f59f11771cbf77";
      aarch64-linux = "64adb41a7a1b14b21d463b333f3f4470a4db9140e288d379bf79510c83091d5ca27e997961d757cee2329b85d16da6da8a1038a00aeabb1e74ab8f95b841ad0a";
=======
      x86_64-linux  = "35e50e05fba0240aa5b138bc1c81f67addaf557701f8df41c682b5bc708f7455";
      x86_64-darwin = "698b6000788e123b647c988993f710c6d9bc44eb8c8e6f97d6b18a695a61f0a6";
      aarch64-linux = "69694856fde11836eb1613bf3a2ba31fbdc933f58c8527b6180f6122c8bb528b";
    }
    else {
      x86_64-linux  = "3a2da2e63bc08ee1886db29c80103c669d3ed6960290b8b97d771232769f282e";
      x86_64-darwin = "655ab873e16257827f884f67b66d62c4da40a895d06206faa435615ad0a56796";
      aarch64-linux = "235cf57afb619801808d5fe1bff7e01a4a9b29f77723566e5371b5f3b2bf8fad";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  this = stdenv.mkDerivation rec {
    version = elk7Version;
    pname = "logstash${lib.optionalString (!enableUnfree) "-oss"}";


    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/logstash/${pname}-${version}-${plat}-${arch}.tar.gz";
<<<<<<< HEAD
      sha512 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
=======
      sha256 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
         --set JAVA_HOME "${jre}"

      wrapProgram $out/bin/logstash-plugin \
         --set JAVA_HOME "${jre}"
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
      license = if enableUnfree then licenses.elastic else licenses.asl20;
      platforms = platforms.unix;
      maintainers = with maintainers; [ wjlroe offline basvandijk ];
    };
    passthru.tests =
      lib.optionalAttrs (config.allowUnfree && enableUnfree) (
        assert this.drvPath == nixosTests.elk.unfree.ELK-7.elkPackages.logstash.drvPath;
        {
          elk = nixosTests.elk.unfree.ELK-7;
        }
      );
  };
in
this
