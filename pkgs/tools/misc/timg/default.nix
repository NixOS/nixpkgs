{ stdenv, pkgs, fetchFromGitHub }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "timg-${version}";
  version = "2018-04-22";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "timg";
    rev = "4a300cfe9c159ffb5d357b41b3c69c57219da9e8";
    sha256 = "0vx4i1ibgc0rmjdb607qbdbwxz9m89vam3hgzz2kvji1zl4b90ns";
  };

  nativeBuildInputs = with pkgs; [gnumake];
  buildInputs = with pkgs; [libwebp graphicsmagick];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''make -C src'';
  installPhase = ''
    mkdir -p "$out/bin/"
    cp -a src/timg "$out/bin/timg"
  '';

  meta = {
    license = licenses.gpl2;
    homepage = "https://github.com/hzeller/timg";
    description = "A viewer that uses 24-Bit color capabilities and 1x2 unicode character blocks to display images in the terminal.";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
