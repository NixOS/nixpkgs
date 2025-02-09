{
  apr,
  aprutil,
  directoryListingUpdater,
  fetchurl,
  lib,
  mod_ca,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "mod_crl";
  version = "0.2.4";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    hash = "sha256-w8YIhed9J1uo5uwhfOVe5LhNLUvFZCgUO4FrHm344Rg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    apr
    aprutil
    mod_ca
  ];

  inherit (mod_ca) configureFlags installFlags;

  passthru.updateScript = directoryListingUpdater {
    url = "https://redwax.eu/dist/rs/";
  };

  meta = with lib; {
    description = "RedWax module for Certificate Revocation Lists";
    homepage = "https://redwax.eu";
    changelog = "https://source.redwax.eu/projects/RS/repos/mod_crl/browse/ChangeLog";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}
