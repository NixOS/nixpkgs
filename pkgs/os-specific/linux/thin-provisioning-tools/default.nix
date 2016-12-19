{ stdenv, fetchFromGitHub, autoconf, pkgconfig, utillinux, coreutils, expat, libaio, boost}:

let
  version = "0.6.1";
in

stdenv.mkDerivation {
  name = "thin-provisioning-tools-${version}";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = "thin-provisioning-tools";
    rev = "e46bdfd4cc6cdb13852de8aba4e3019425ab0a89";
    sha256 = "061rw33nw16g71ij05axl713wimawx54h2ggpqxvzy7iyi6lhdcm";
  };

  nativeBuildInputs = [ autoconf pkgconfig expat libaio boost ];

  preConfigure =
    ''
      autoconf
    '';

  meta = {
    homepage = https://github.com/jthornber/thin-provisioning-tools;
    descriptions = "Tools for manipulating the metadata of the device-mapper targets (dm-thin-pool, dm-cache, dm-era)";
    platforms = stdenv.lib.platforms.linux;
    inherit version;
  };
}
