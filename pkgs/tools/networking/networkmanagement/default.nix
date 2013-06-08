{ stdenv, fetchurl, gettext, kdelibs, kde_workspace, networkmanager, pkgconfig }:

let
  pname = "networkmanagement";
  version = "0.9.0.4";
  name = "${pname}-${version}";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://kde/unstable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "0mp2jai6f2qpywjwgvxcl1nh27idgy740vwiahfamq8w2y90a3aj";
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
