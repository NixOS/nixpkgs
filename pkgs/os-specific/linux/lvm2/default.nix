{stdenv, fetchurl, devicemapper}:

stdenv.mkDerivation {
  name = "lvm2-2.02.17";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.17.tgz;
    md5 = "a1bebdabb0dace2b9dd98579625ce53c";
  };
  buildInputs = [devicemapper];
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";
}
