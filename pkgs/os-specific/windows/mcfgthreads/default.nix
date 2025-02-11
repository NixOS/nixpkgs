{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "mcfgthread";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "lhmouse";
    repo = "mcfgthread";
    rev = "v${lib.versions.majorMinor version}-ga.${lib.versions.patch version}";
    hash = "sha256-bB7ghhSqAqkyU1PLuVVJfkTYTtEU9f0CR1k+k+u3EgY=";
  };

  postPatch = ''
    sed -z "s/Rules for tests.*//;s/'cpp'/'c'/g" -i meson.build
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "Threading support library for Windows 7 and above";
    homepage = "https://github.com/lhmouse/mcfgthread/wiki";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.windows;
  };
}
