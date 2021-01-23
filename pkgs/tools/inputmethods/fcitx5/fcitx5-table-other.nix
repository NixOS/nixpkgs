{ lib, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, gettext
, libime
, boost
, fcitx5
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-table-other";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-table-other";
    rev = version;
    sha256 = "sha256-P+KaUmjAHe1CZ5rNMQAxwKSW5ZMVgQcwkgdlungXTLM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
    libime
    boost
    fcitx5
  ];

  meta = with lib; {
    description = "Some other tables for Fcitx";
    homepage = "https://github.com/fcitx/fcitx5-table-other";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
