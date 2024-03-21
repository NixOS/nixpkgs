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
  version = "0.2.2";

  src = fetchurl {
    url = "https://redwax.eu/dist/rs/${pname}-${version}.tar.gz";
    sha256 = "0gs66br3aig749rzifxn6j1rz2kps4hc4jppscly48lypgyygy8s";
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

  meta = with lib; {
    description = "RedWax CA service module";
    homepage = "https://redwax.eu";
    changelog = "https://source.redwax.eu/projects/RS/repos/mod_ca/browse/ChangeLog";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dirkx ];
  };
}
