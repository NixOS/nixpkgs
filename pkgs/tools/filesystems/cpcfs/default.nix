{ lib, stdenv, fetchFromGitHub, makeWrapper, ncurses, readline, ronn }:

stdenv.mkDerivation rec {

  pname = "cpcfs";
  version = "0.85.4";

  src = fetchFromGitHub {
    owner = "derikz";
    repo = "cpcfs";
    rev = "v${version}";
    sha256 = "0rfbry0qy8mv746mzk9zdfffkdgq4w7invgb5cszjma2cp83q3i2";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [ makeWrapper ncurses readline ronn ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-ltermcap' '-lncurses' \
      --replace '-L /usr/lib/termcap' ' '
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/man/man1
    cp cpcfs $out/bin
    ronn --roff ../template.doc --pipe > $out/man/man1/cpcfs.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Manipulating CPC dsk images and files";
    mainProgram = "cpcfs";
    homepage = "https://github.com/derikz/cpcfs/" ;
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
