{stdenv, fetchurl, devicemapper, static ? false}:

stdenv.mkDerivation {
  name = "lvm2-2.02.26";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.26.tgz;
    sha256 = "6a177953f1a81aff91144b6bea8eb5f73f6139b10bffd5946c22a32f586ab899";
  };
  buildInputs = [devicemapper];
  configureFlags = if static then "--enable-static_link" else "";
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";
}
