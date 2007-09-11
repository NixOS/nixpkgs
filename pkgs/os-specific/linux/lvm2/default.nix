{stdenv, fetchurl, devicemapper, static ? false}:

stdenv.mkDerivation {
  name = "lvm2-2.02.28";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.28.tgz;
    sha256 = "1sxchdz31mz57gm25jjphawhx2c8zmyw3mvifkxhnza27q97p39d";
  };
  buildInputs = [devicemapper];
  configureFlags = if static then "--enable-static_link" else "";
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";
}
