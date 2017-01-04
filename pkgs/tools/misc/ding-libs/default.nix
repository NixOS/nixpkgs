{ stdenv, fetchurl, glibc, doxygen, check }:

let
  name = "ding-libs";
  version = "0.6.0";
in stdenv.mkDerivation {
  inherit name;
  inherit version;

  src = fetchurl {
    url = "https://fedorahosted.org/released/${name}/${name}-${version}.tar.gz";
    sha1 = "c8ec86cb93a26e013a13b12a7b0b3fbc1bca16c1";
  };

  enableParallelBuilding = true;
  buildInputs = [ glibc doxygen check ];

  buildFlags = "docs";
  doCheck = true;

  meta = {
    description = "'D is not GLib' utility libraries";
    homepage = https://fedorahosted.org/sssd/;
    maintainers = with stdenv.lib.maintainers; [ e-user ];
    license = [ stdenv.lib.licenses.gpl3 stdenv.lib.licenses.lgpl3 ];
  };
}
