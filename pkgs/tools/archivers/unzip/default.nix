{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "unzip-5.52";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/unzip552.tar.gz;
    md5 = "9d23919999d6eac9217d1f41472034a9";
  };

  meta = {
	  homepage = http://www.info-zip.org;
  };
}
