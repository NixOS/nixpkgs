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
  pname = "mod_csr";
  version = "0.2.4";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    hash = "sha256-JVd5N5UnAxDwq6AavEHA0HsY2TRa+9RmLLJeRZbj+4Q=";
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
    description = "RedWax CA service module to handle Certificate Signing Requests";
    homepage = "https://redwax.eu";
    changelog = "https://source.redwax.eu/projects/RS/repos/mod_csr/browse/ChangeLog";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}
