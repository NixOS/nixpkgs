{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, qttools
, qtwayland
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "pokefinder";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "Admiral-Fish";
    repo = "PokeFinder";
    rev = "v${version}";
    sha256 = "j7xgjNF8NWLFVPNItWcFM5WL8yPxgHxVX00x7lt45WI=";
    fetchSubmodules = true;
  };

  patches = [ ./cstddef.patch ];

  postPatch = ''
    patchShebangs Source/Core/Resources/
  '';

  installPhase = lib.optionalString (!stdenv.isDarwin) ''
    install -D Source/Forms/PokeFinder $out/bin/PokeFinder
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -R Source/Forms/PokeFinder.app $out/Applications
  '';

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [ qtbase qttools ]
    ++ lib.optionals stdenv.isLinux [ qtwayland ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/Admiral-Fish/PokeFinder";
    description = "Cross platform Pokémon RNG tool";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ leo60228 ];
  };
}
