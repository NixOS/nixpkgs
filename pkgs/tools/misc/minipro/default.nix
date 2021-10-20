{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "minipro";
  version = "0.5";

  src = fetchFromGitLab {
    owner = "DavidGriffith";
    repo = "minipro";
    rev = version;
    sha256 = "sha256-Hyj2LyY7W8opjigH+QLHHbDyelC0LMgGgdN+u3nNoJc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];
  makeFlags = [
    "PREFIX=$(out)"
    "UDEV_DIR=$(out)/lib/udev"
    "COMPLETIONS_DIR=$(out)/share/bash-completion/completions"
    "PKG_CONFIG=${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/DavidGriffith/minipro";
    description = "An open source program for controlling the MiniPRO TL866xx series of chip programmers";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bmwalters ];
  };
}
