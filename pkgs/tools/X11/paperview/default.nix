{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "paperview";
  version = "unstable-2020-09-22";

  src = fetchFromGitHub {
    owner = "glouw";
    repo = "paperview";
    rev = "40162fb76566fec8163c338c169c2fcd9df6ef42";
    hash = "sha256-rvf89vMIT274+Hva+N4KFu1iT2XE6fq5Bi4kOQg2M0g=";
  };

  buildInputs = [
    SDL2
    libX11
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "A high performance X11 animated wallpaper setter";
    homepage = "https://github.com/glouw/paperview";
    platforms = platforms.linux;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "paperview";
  };
}
