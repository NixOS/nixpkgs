{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libassuan,
  libgpg-error,
  popt,
  bemenu,
}:

stdenv.mkDerivation rec {
  pname = "pinentry-bemenu";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "t-8ch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m6P8/cCdGH2c9ne8aLrh6pUJ6Ekn+CNyEn3WlD2LhU8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    libassuan
    libgpg-error
    popt
    bemenu
  ];

  meta = with lib; {
    description = "Pinentry implementation based on bemenu";
    homepage = "https://github.com/t-8ch/pinentry-bemenu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jc ];
    platforms = with platforms; linux;
    mainProgram = "pinentry-bemenu";
  };
}
