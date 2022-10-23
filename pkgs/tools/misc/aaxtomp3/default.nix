{ stdenv, pkgs, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "aaxtomp3";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "KrumpetPirate";
    repo = "AAXtoMP3";
    rev = "v${version}";
    sha256 = "sha256-7a9ZVvobWH/gPxa3cFiPL+vlu8h1Dxtcq0trm3HzlQg=";
  };

  installPhase = ''
    mkdir -p $out/bin
    chmod +x AAXtoMP3 interactiveAAXtoMP3
    mv AAXtoMP3 interactiveAAXtoMP3 $out/bin
  '';

  propogatedBuildInputs = with pkgs; [
    bash
    ffmpeg
    lame
    gnugrep
    gnused
    jq
    mediainfo
    bc
  ];

  meta = with lib; {
    description = "Convert Audible's .aax filetype to MP3, FLAC, M4A, or OPUS";
    homepage = "https://github.com/KrumpetPirate/AAXtoMP3";
    license = licenses.wtfpl;
    maintainers = [ maintainers.jo1gi ];
    platforms = platforms.all;
  };
}
