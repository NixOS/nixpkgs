{stdenv, fetchurl, devicemapper}:

stdenv.mkDerivation {
  name = "lvm2-2.02.22";
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/lvm2/old/LVM2.2.02.22.tgz;
    sha256 = "1izcjv3g2xrma79xswdk8n1bm3rg1h70ccdp167wnwjca8rs56i8";
  };
  buildInputs = [devicemapper];
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";
}
