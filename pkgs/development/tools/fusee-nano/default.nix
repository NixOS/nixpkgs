{ lib, stdenv, fetchFromGitHub, unixtools }:

stdenv.mkDerivation {
  pname = "fusee-nano";
  version = "unstable-2023-05-17";

  src = fetchFromGitHub {
    owner = "DavidBuchanan314";
    repo = "fusee-nano";
    rev = "2979d34f470d02f34594d8d59be1f5c7bf4bf73f";
    hash = "sha256-RUG10wvhB0qEuiLwn8wk6Uxok+gv4bFLD6tbx0P0yDc=";
  };

  nativeBuildInputs = [ unixtools.xxd ];

  makeFlags = [ "PREFIX=$(out)/bin" ];

  meta = {
    description = "A minimalist re-implementation of the Fusée Gelée exploit";
    mainProgram = "fusee-nano";
    homepage = "https://github.com/DavidBuchanan314/fusee-nano";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
