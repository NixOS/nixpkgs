{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  fcitx5,
  m17n_lib,
  m17n_db,
  gettext,
  fmt,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-m17n";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-5zXLbKHcTMrX+Ux9aN2jl15Go58m7Fr7ZkFyvDGWKaw=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    gettext
  ];

  buildInputs = [
    fcitx5
    m17n_db
    m17n_lib
    fmt
  ];

  passthru.tests = {
    inherit (nixosTests) fcitx5;
  };

  meta = with lib; {
    description = "m17n support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-m17n";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ Technical27 ];
    platforms = platforms.linux;
  };
}
