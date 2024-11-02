{
  lib,
  stdenv,
  fetchurl,
  unzip,
  joker,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goku";
  version = "0.7.2";

  src =
    if stdenv.hostPlatform.isAarch64 then
      fetchurl {
        url = "https://github.com/yqrashawn/GokuRakuJoudo/releases/download/v${finalAttrs.version}/goku-arm.zip";
        hash = "sha256-mjz1JD12U23Pi8kumELtT9ENhXpX8Db4LUS3DOtP5GM=";
      }
    else
      fetchurl {
        url = "https://github.com/yqrashawn/GokuRakuJoudo/releases/download/v${finalAttrs.version}/goku.zip";
        hash = "sha256-8HdIwtpzR6O2WCbMYIJ6PHcM27Xmb+4Tc5Fmjl0dABQ=";
      };

  nativeBuildInputs = [ unzip ];

  buildInputs = [ joker ];

  sourceRoot = if stdenv.hostPlatform.isAarch64 then "goku" else ".";

  passthru.updateScript = nix-update-script { };

  installPhase = ''
    chmod +x goku
    chmod +x gokuw
    mkdir -p $out/bin
    cp goku $out/bin
    cp gokuw $out/bin
  '';

  meta = {
    description = "Karabiner configurator";
    homepage = "https://github.com/yqrashawn/GokuRakuJoudo";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nikitavoloboev ];
    platforms = lib.platforms.darwin;
  };
})
