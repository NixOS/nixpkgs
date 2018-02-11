{ stdenv, fetchurl, python, lvm2, dmraid }:

stdenv.mkDerivation rec {
  name = "pyblock-${version}";
  version = "0.53";
  md5_path = "f6d33a8362dee358517d0a9e2ebdd044";

  src = fetchurl rec {
    url = "http://src.fedoraproject.org/repo/pkgs/python-pyblock/"
        + "${name}.tar.bz2/${md5_path}/${name}.tar.bz2";
    sha256 = "f6cef88969300a6564498557eeea1d8da58acceae238077852ff261a2cb1d815";
  };

  postPatch = ''
    sed -i -e 's|/usr/include/python|${python}/include/python|' \
           -e 's/-Werror *//' -e 's|/usr/|'"$out"'/|' Makefile
  '';

  buildInputs = [ python lvm2 dmraid ];

  makeFlags = [
    "USESELINUX=0"
    "SITELIB=$(out)/lib/${python.libPrefix}/site-packages"
  ];

  meta = {
    description = "Interface for working with block devices";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
