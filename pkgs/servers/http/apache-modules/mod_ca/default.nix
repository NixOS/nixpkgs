{
  apacheHttpd,
  apr,
  aprutil,
  directoryListingUpdater,
  fetchurl,
  lib,
  openldap,
  openssl,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "mod_ca";
  version = "0.2.3";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    hash = "sha256-HGnhypOO0WOgRw9i9oqO4da131zAwBXOdrc9dypFjyk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    apacheHttpd
    apr
    aprutil
    openldap
    openssl
  ];

  # Note that configureFlags and installFlags are inherited by
  # the various submodules.
  #
  configureFlags = [ "--with-apxs=${apacheHttpd.dev}/bin/apxs" ];

  installFlags = [
    "INCLUDEDIR=${placeholder "out"}/include"
    "LIBEXECDIR=${placeholder "out"}/modules"
  ];

  passthru.updateScript = directoryListingUpdater {
    url = "https://redwax.eu/dist/rs/";
  };

  meta = {
    description = "RedWax CA service module";
    homepage = "https://redwax.eu";
    changelog = "https://source.redwax.eu/projects/RS/repos/mod_ca/browse/ChangeLog";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dirkx ];
  };
}
