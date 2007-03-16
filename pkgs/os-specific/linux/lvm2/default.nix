{stdenv, fetchurl, devicemapper}:

stdenv.mkDerivation {
  name = "lvm2-2.02.17";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/lvm2/old/LVM2.2.02.17.tgz;
    sha256 = "12bbr0rg5cmysmdvz6pv2fz9yhcff3fmivdcy2qaxn4p412255sj";
  };
  buildInputs = [devicemapper];
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";
}
