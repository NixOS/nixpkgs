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
  pname = "mod_ocsp";
  version = "0.2.2";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "0wy5363m4gq1w08iny2b3sh925bnznlln88pr9lgj9vgbn8pqnrn";
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
    description = "RedWax CA service modules of OCSP Online Certificate Validation";
    homepage = "https://redwax.eu";
    changelog = "https://source.redwax.eu/projects/RS/repos/mod_csr/browse/ChangeLog";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}
