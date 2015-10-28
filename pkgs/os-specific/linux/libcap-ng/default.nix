{ stdenv, fetchurl, pkgs, python, linuxHeaders
, pythonSupport ? false, swig, python3
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-ng-${version}";
  version = "0.7.7";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "615549ce39b333f6b78baee0c0b4ef18bc726c6bf1cca123dfd89dd963f6d06b";
  };

  preBuild = ''
    for python in python python3; do
      substituteInPlace "bindings/$python/Makefile" \
        --replace "/usr/include/linux" "${pkgs.linuxHeaders}/include/linux"
    done
  '';

  buildInputs = with pkgs; [ python linuxHeaders ]
  # TODO: allow building only python2
  ++ stdenv.lib.optional pythonSupport [ swig python3 ];

  configureFlags = if pythonSupport then "--with-python=$(python3)/bin/python3" else "--without-python3";

  meta = {
    description = "Library for working with POSIX capabilities";
    homepage = http://people.redhat.com/sgrubb/libcap-ng/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl21;
  };
}
