{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "interception-k2k";
  version = "0-unstable-2024-11-06";

  src = fetchFromGitHub {
    owner = "zsugabubus";
    repo = finalAttrs.pname;
    rev = "5746bf39a321610bb6019781034f82e4c6e21e97";
    hash = "sha256-q2zlOvyW5jlasEIPVc+k6jh2wJZ7sUEpvXh/leH/hKw=";
  };

  makeFlags = [ "INSTALL_DIR=${placeholder "out"}/bin" ];

  meta = {
    homepage = "https://github.com/zsugabubus/interception-k2k";
    description = "Configurable plugin for Interception Tools (caps2esc, space2meta, tab2altgr...)";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ musjj ];
  };
})
