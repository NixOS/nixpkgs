{ lib, buildPythonPackage, fetchurl, pkgconfig, gtk2, libX11, libXtst, libXi, libxkbfile, xorgproto }:

let
  majorVersion = "0.63";
  minorVersion = "0";
in buildPythonPackage rec {
  pname = "virtkey";
  version = "${majorVersion}.${minorVersion}";

  src = fetchurl {
    url = "https://launchpad.net/virtkey/${majorVersion}/${version}/+download/virtkey-${version}.tar.gz";
    sha256 = "0hd99hrxn6bh3rxcrdnad5cqjsphrn1s6fzx91q07d44k6cg6qcr";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gtk2 libX11 libXtst libXi libxkbfile xorgproto ];

  meta = with lib; {
    description = "Extension to emulate keypresses and to get the layout information from the X server";
    homepage = https://launchpad.net/virtkey;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
