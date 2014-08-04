{ stdenv, fetchurl, pkgconfig, cmake, gettext, kdelibs, networkmanager, libnm-qt }:

let
  pname = "plasma-nm";
  version = "0.9.3.3";
  name = "${pname}-${version}";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://kde/unstable/${pname}/${name}.tar.xz";
    sha256 = "099cbe86eb989c4fda8cdcc0f8721dc3350cc6735c3f50bcdd94661e5930e326";
  };

  buildInputs = [
    cmake
    pkgconfig
    gettext
    kdelibs
    networkmanager
    libnm-qt
  ];

  meta = with stdenv.lib; {
    homepage = "https://projects.kde.org/projects/kde/workspace/plasma-nm";
    description = "Plasma applet written in QML for managing network connections";
    license = licenses.lgpl21;
    inherit (kdelibs.meta) platforms;
    maintainers = [ maintainers.jgeerds ];
  };
}
