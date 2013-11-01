{ stdenv, fetchurl, gettext, kdelibs, kde_workspace, networkmanager, pkgconfig }:

let
  pname = "networkmanagement";
  version = "0.9.0.9";
  name = "${pname}-${version}";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://kde/unstable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "1jiij9iz8v9mgcq811svmlyfvmvkazpclkf4yk7193m4y8yn19yn";
  };

  buildInputs = [ kdelibs kde_workspace networkmanager ];
  nativeBuildInputs = [ gettext pkgconfig ];

  NIX_CFLAGS_COMPILE="-I${kde_workspace}/include/solid/control";

  meta = {
    homepage = https://projects.kde.org/projects/extragear/base/networkmanagement;
    description = "KDE Plasmoid for controlling NetworkManager";
    inherit (kdelibs.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
