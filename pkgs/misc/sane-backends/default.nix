{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sane-backends-1.0.16";
  src = fetchurl {
    url = ftp://ftp3.sane-project.org/pub/sane/old-versions/sane-backends-1.0.16/sane-backends-1.0.16.tar.gz;
    md5 = "bec9b9262246316b4ebfe2bc7451aa28";
  };
}
