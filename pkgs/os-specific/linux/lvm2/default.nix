{stdenv, fetchurl, devicemapper}:

stdenv.mkDerivation {
  name = "lvm2-2.02.38";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.38.tgz;
    sha256 = "13nx6iqgga3ric51b36p15cxzhmh83s7spb2559iz3s24x4s0845";
  };
  buildInputs = [devicemapper];
  configureFlags = if stdenv ? isStatic then "--enable-static_link" else "";
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";
}
