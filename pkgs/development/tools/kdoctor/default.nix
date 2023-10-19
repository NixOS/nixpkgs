{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdoctor";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/Kotlin/${finalAttrs.pname}/releases/download/v${finalAttrs.version}/kdoctor_${finalAttrs.version}+92.zip";
    hash = "sha256-rGK5U1JeXID9OcT8uzO3oO6f9MZgrW69LUHbEtj0SSQ=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    runHook preUnpack
    unzip $src -x META-INF/*
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 kdoctor -t $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Environment analysis tool for Kotlin Multiplatform Mobile";
    longDescription = ''
      KDoctor is a command-line tool that helps to set up the environment for
      Kotlin Multiplatform Mobile app development.
    '';
    homepage = "https://github.com/Kotlin/kdoctor";
    license = licenses.asl20;
    mainProgram = "kdoctor";
    maintainers = with maintainers; [ sironheart ];
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
