{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_mixer, SDL2_ttf, libsodium, pkg-config }:
stdenv.mkDerivation rec {
  pname = "devilutionx";
  version = "unstable-2020-10-20";

  src = fetchFromGitHub {
    owner = "diasurgical";
    repo = "devilutionX";
    rev = "432fbc8ef7b98e567b08e44ce91b198374a5ff01";
    sha256 = "03w3bgmzwsbycx3fzvn47fsmabl069gw77yn2fqg89wlgaw1yrr9";
  };

  NIX_CFLAGS_COMPILE = [
    "-I${SDL2_ttf}/include/SDL2"
    ''-DTTF_FONT_PATH="${placeholder "out"}/share/fonts/truetype/CharisSILB.ttf"''
  ];

  cmakeFlags = [
    "-DBINARY_RELEASE=ON"
  ];

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ libsodium SDL2 SDL2_mixer SDL2_ttf ];

  installPhase = ''
    runHook preInstall

  '' + (if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    mv devilutionx.app $out/Applications
  '' else ''
    install -Dm755 -t $out/bin devilutionx
    install -Dt $out/share/fonts/truetype ../Packaging/resources/CharisSILB.ttf

    # TODO: icons and .desktop (see Packages/{debian,fedora}/*)
  '') + ''

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/diasurgical/devilutionX";
    description = "Diablo build for modern operating systems";
    longDescription = "In order to play this game a copy of diabdat.mpq is required. Place a copy of diabdat.mpq in ~/.local/share/diasurgical/devilution before executing the game.";
    license = licenses.unlicense;
    maintainers = [ maintainers.karolchmist ];
    platforms = platforms.linux ++ platforms.windows;
  };
}
