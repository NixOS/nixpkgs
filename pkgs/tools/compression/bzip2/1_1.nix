{ lib, stdenv
, fetchFromGitLab
, meson
, python3
, ninja
}:

stdenv.mkDerivation rec {
  pname = "bzip2-unstable";
  version = "2020-08-11";

  src = fetchFromGitLab {
    owner = "federicomenaquintero";
    repo = "bzip2";
    rev = "15255b553e7c095fb7a26d4dc5819a11352ebba1";
    sha256 = "sha256-BAyz35D62LWi47B/gNcCSKpdaECHBGSpt21vtnk3fKs=";
  };

  postPatch = ''
    patchShebangs install_links.py
  '';

  nativeBuildInputs = [
    meson
    python3
    ninja
  ];

  outputs = [ "bin" "dev" "out" "man" ];

  mesonFlags = [
    "-Ddocs=disabled"
  ];

  strictDeps = true;

  meta = with lib; {
    description = "High-quality data compression program";
    license = licenses.bsdOriginal;
    platforms = platforms.all;
    maintainers = [];
  };
}
