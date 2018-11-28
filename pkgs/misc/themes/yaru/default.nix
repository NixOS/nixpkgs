{ stdenv, fetchFromGitHub, meson, ninja, sassc, gtk3, python3 }:

stdenv.mkDerivation rec {
  name = "yaru-theme-${version}";
  version = "18.10.7";

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "yaru";
    rev = version;
    sha256 = "1aryri3jk16yrgrhr6c16lfci16cknra28h4k02kfxb51xx7ih60";
  };

  nativeBuildInputs = [ meson ninja sassc python3 ];
  buildInputs = [ gtk3 ];

  postPatch = ''
    for x in icons/meson/post_install.py sessions/meson/{compile-schemas,install-dock-override}; do
      chmod +x $x
      patchShebangs $x
    done
  '';

  meta = with stdenv.lib; {
    description = "Ubuntu community theme";
    homepage = https://github.com/ubuntu/yaru;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.dtzWill ];
  };
}

