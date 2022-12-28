{ lib, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, extra-cmake-modules
, gettext
, fcitx5
, librime
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-rime";
  version = "5.0.15";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-gSot+jxZn2m/RQP9ELN/S5sh5uQfhA1s45+N5svN5fg=";
  };

  cmakeFlags = [
    "-DRIME_DATA_DIR=${placeholder "out"}/share/rime-data"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    gettext
  ];

  buildInputs = [
    fcitx5
    librime
  ];

  patches = [ ./fcitx5-rime-with-nix-env-variable.patch ];

  meta = with lib; {
    description = "RIME support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-rime";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
