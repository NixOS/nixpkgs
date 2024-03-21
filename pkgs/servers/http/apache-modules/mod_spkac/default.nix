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
  pname = "mod_spkac";
  version = "0.2.2";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "0hpr58yazbi21m0sjn22a8ns4h81s4jlab9szcdw7j9w9jdc7j0h";
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
    description = "RedWax CA service module for handling the Netscape keygen requests. ";
    homepage = "https://redwax.eu";
    changelog = "https://source.redwax.eu/projects/RS/repos/mod_spkac/browse/ChangeLog";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}
