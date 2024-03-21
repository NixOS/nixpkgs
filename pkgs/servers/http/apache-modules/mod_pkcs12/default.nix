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
  pname = "mod_pkcs12";
  version = "0.2.2";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "1jfyax3qrw9rpf2n0pn6iw4dpn2nl4j0i2a998n5p1mdmjx9ch73";
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
    description = "RedWax CA service modules for PKCS#12 format files";
    homepage = "https://redwax.eu";
    changelog = "https://source.redwax.eu/projects/RS/repos/mod_pkcs12/browse/ChangeLog";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}
