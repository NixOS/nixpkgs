{ stdenv, fetchurl, gettext, kdelibs, kde_workspace, networkmanager, pkgconfig }:

let
  pname = "networkmanagement";
  version = "0.8.98";
  name = "${pname}-${version}";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://kde/unstable/${pname}/${version}/src/${name}.tar.bz2";
    sha256 = "0bb8096q6yx4657jc20f50mfsjyfd1wz0npa6in030ydzm5jk3ax";
  };

  buildInputs = [ kdelibs kde_workspace networkmanager ];
  buildNativeInputs = [ gettext pkgconfig ];

  NIX_CFLAGS_COMPILE="-I${kde_workspace}/include/solid/control";

  meta = {
    homepage = https://projects.kde.org/projects/extragear/base/networkmanagement;
    description = "KDE Plasmoid for controlling NetworkManager";
    inherit (kdelibs.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
