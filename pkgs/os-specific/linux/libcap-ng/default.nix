{ stdenv, fetchurl, python }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-ng-${version}";
  version = "0.7.3";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "1cavlcrpqi4imkmagjhw65br8rv2fsbhf68mm3lczr51sg44392w";
  };

  buildInputs = [ python ]; # ToDo? optional swig for python bindings

  meta = {
    description = "Library for working with POSIX capabilities";
    homepage = http://people.redhat.com/sgrubb/libcap-ng/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl21;
  };
}
