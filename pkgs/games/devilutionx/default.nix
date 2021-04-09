{ lib, stdenv, fetchFromGitHub, cmake, SDL2, SDL2_mixer, SDL2_ttf, libsodium, pkg-config }:

stdenv.mkDerivation rec {
  pname = "devilutionx";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "diasurgical";
    repo = "devilutionX";
    rev = version;
    sha256 = "034xkz0a7j2nba17mh44r0kamcblvykdwfsjvjwaz2mrcsmzkr9z";
  };

  postPatch = ''
    substituteInPlace Source/init.cpp --replace "/usr/share/diasurgical/devilutionx/" "${placeholder "out"}/share/diasurgical/devilutionx/"
  '';

  NIX_CFLAGS_COMPILE = [
    "-I${SDL2_ttf}/include/SDL2"
    ''-DTTF_FONT_PATH="${placeholder "out"}/share/fonts/truetype/CharisSILB.ttf"''
  ];

  cmakeFlags = [
    "-DBINARY_RELEASE=ON"
    "-DVERSION_NUM=${version}"
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
    install -Dt $out/share/diasurgical/devilutionx ../Packaging/resources/devilutionx.mpq

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
