{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, makeWrapper
, SDL
, SDL_mixer
, SDL_net
, wxGTK32
}:

stdenv.mkDerivation rec {
  pname = "odamex";
  version = "0.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-src-${version}.tar.bz2";
    sha256 = "sha256-WBqO5fWzemw1kYlY192v0nnZkbIEVuWmjWYMy+1ODPQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    SDL
    SDL_mixer
    SDL_net
    wxGTK32
  ];

  installPhase = ''
    runHook preInstall
  '' + (if stdenv.isDarwin then ''
    mkdir -p $out/{Applications,bin}
    mv odalaunch/odalaunch.app $out/Applications
    makeWrapper $out/{Applications/odalaunch.app/Contents/MacOS,bin}/odalaunch
  '' else ''
    make install
  '') + ''
    runHook postInstall
  '';

  meta = {
    homepage = "http://odamex.net/";
    description = "Client/server port for playing old-school Doom online";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
  };
}
