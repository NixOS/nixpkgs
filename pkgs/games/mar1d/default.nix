{ stdenv
, lib
, SDL2
, SDL2_mixer
, libGLU
, libconfig
, meson
, ninja
, pkg-config
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "MAR1D";
  version = "0.3.1";

  src = fetchFromGitHub {
    sha256 = "sha256-c48azBGdnzhEQGUeRJWlNLJhtrYjnpiORuWvowcQK5Y=";
    rev = "v${version}";
    repo = "MAR1D";
    owner = "Radvendii";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [
    SDL2
    SDL2_mixer
    libconfig
    libGLU
  ];

  meta = with lib; {
    description = "First person Super Mario Bros";
    longDescription = ''
      The original Super Mario Bros as you've never seen it. Step into Mario's
      shoes in this first person clone of the classic Mario game. True to the
      original, however, the game still takes place in a two dimensional world.
      You must view the world as mario does, as a one dimensional line.
    '';
    homepage = "https://mar1d.com";
    license = licenses.agpl3;
    maintainers = with maintainers; [ taeer ];
    platforms = platforms.unix;
  };
}
