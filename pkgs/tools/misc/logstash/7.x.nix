{
  config,
  elk7Version,
  enableUnfree ? true,
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  nixosTests,
  jre,
}:

let
  info = lib.splitString "-" stdenv.hostPlatform.system;
  arch = lib.elemAt info 0;
  plat = lib.elemAt info 1;
  hashes =
    if enableUnfree then
      {
        x86_64-linux = "sha512-9JzopnY43Osoy4/0G9gxJYlbCl1a9Qy2pL4GL1uyjJ3uSNoOskEBhhsqLp9BhtJXOaquuRDgbJnXhbBrlE0rKg==";
        x86_64-darwin = "sha512-ZcdKWFrIQUmGtxoWbLc2F7g85quXfRqy62DyVPR/9zBtMTgFH0eG4Cj40ELpW7nYXZqglmAUTF/0mZZYUg2Ciw==";
        aarch64-linux = "sha512-V2Nt/lup4ofgoMqpAH3OHF8Fp0PvC1M8nl6sCKmTf+ZXQYHNjAJkJwGJwHeQQ0L/348JHyCkeWL43dS7Jr6ZJQ==";
      }
    else
      {
        x86_64-linux = "sha512-L11ZUdXC8VDiSEVDBMous2OaMlAFgvkQ+eDbmbA9r/sDIXY8W7dx3jgPNXoorDtatTemwy8aXw1XJGaVmj4T3Q==";
        x86_64-darwin = "sha512-az5ujFtwcuNNGuITDeGRu1FB2bb8/hIUmGMvm0Xcfvs0GZPnCZVY6ScsiHZYjT8X+qBYkn/httT3MYozrPOy4Q==";
        aarch64-linux = "sha512-iVft0kZYhvFJ1NKCfdePhRxDljPTwV+3G7wV94iykYISgLTVoehzDTMdxUyfK/mmQhu3hmmHbVpw1jXjTrS7ng==";
      };
  this = stdenv.mkDerivation rec {
    version = elk7Version;
    pname = "logstash${lib.optionalString (!enableUnfree) "-oss"}";

    src = fetchurl {
      url = "https://artifacts.elastic.co/downloads/logstash/${pname}-${version}-${plat}-${arch}.tar.gz";
      hash = hashes.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
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
        binaryBytecode # source bundles dependencies as jars
        binaryNativeCode # bundled jruby includes native code
      ];
      license = if enableUnfree then licenses.elastic20 else licenses.asl20;
      platforms = platforms.unix;
      maintainers = with maintainers; [
        offline
        basvandijk
      ];
    };
    passthru.tests = lib.optionalAttrs (config.allowUnfree && enableUnfree) (
      assert this.drvPath == nixosTests.elk.unfree.ELK-7.elkPackages.logstash.drvPath;
      {
        elk = nixosTests.elk.unfree.ELK-7;
      }
    );
  };
in
this
