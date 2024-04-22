{ lib
, stdenvNoCC
, fetchurl
, makeBinaryWrapper
, jre
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "code-maat";
  version = "1.0.4";

  src = fetchurl {
    url = "https://github.com/adamtornhill/code-maat/releases/download/v${finalAttrs.version}/code-maat-${finalAttrs.version}-standalone.jar";
    hash = "sha256-QoeuIDSQGERFD3aVR7xEl6DaGm0cf6b63IWHBeZ0O18=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase =
    let
      jar = "$out/libexec/code-maat/code-maat.jar";
    in
    ''
      runHook preInstall

      install -D ${finalAttrs.src} ${jar}
      mkdir -p "$out/bin"
      makeWrapper "${jre}/bin/java" "$out/bin/code-maat" \
          --add-flags "-jar ${jar}"

      runHook postInstall
    '';

  meta = with lib; {
    description = "A command line tool to mine and analyze data from version-control systems";
    mainProgram = "code-maat";
    homepage = "https://github.com/adamtornhill/code-maat";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ sir4ur0n ];
  };
})
