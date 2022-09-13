{ lib
, stdenv
, fetchzip
, jre_headless
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "riot-redis";
  version = "2.18.1";

  src = fetchzip {
    url = "https://github.com/redis-developer/riot/releases/download/v${version}/riot-redis-${version}.zip";
    sha256 = "sha256-mRuW/mPcqDO2txVwL2MlqZeprNDifjmOx7UUUy3yF3M=";
  };

  buildInputs = [ jre_headless ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/riot-redis $out/bin
    cp -R lib $out
    chmod +x $out/bin/*

    wrapProgram $out/bin/riot-redis \
      --set JAVA_HOME "${jre_headless}"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/redis-developer/riot";
    description = "Get data in and out of Redis";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ wesnel ];
  };
}
