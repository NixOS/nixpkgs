{ lib, stdenv, fetchurl, python, lvm2, dmraid }:

stdenv.mkDerivation rec {
  pname = "pyblock";
  version = "0.53";
  md5_path = "f6d33a8362dee358517d0a9e2ebdd044";

  src = fetchurl {
    url = "https://src.fedoraproject.org/repo/pkgs/python-pyblock/"
        + "${pname}-${version}.tar.bz2/${md5_path}/${pname}-${version}.tar.bz2";
    sha256 = "f6cef88969300a6564498557eeea1d8da58acceae238077852ff261a2cb1d815";
  };

  patches = [
    # Fix build with glibc >= 2.28
    # https://github.com/NixOS/nixpkgs/issues/86403
    ./pyblock-sysmacros.h.patch
  ];

  postPatch = ''
    sed -i -e 's|/usr/include/python|${python}/include/python|' \
           -e 's/-Werror *//' -e 's|/usr/|'"$out"'/|' Makefile
  '';

  buildInputs = [ python lvm2 dmraid ];

  makeFlags = [
    "USESELINUX=0"
    "SITELIB=$(out)/lib/${python.libPrefix}/site-packages"
  ];

  meta = with lib; {
    description = "Interface for working with block devices";
    license = licenses.gpl2Plus;
  };
}
