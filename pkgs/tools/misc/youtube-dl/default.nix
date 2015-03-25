{ stdenv, fetchurl, makeWrapper, python, zip, pandoc, ffmpeg }:

let
  version = "2015.03.24";
in
stdenv.mkDerivation rec {
  name = "youtube-dl-${version}";

  src = fetchurl {
    url = "http://youtube-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "1m462hcgizdp59s9h62hjwhq4vjrgmck23x2bh5jvb9vjpcfqjxv";
  };

  buildInputs = [ python makeWrapper ];
  nativeBuildInputs = [ zip pandoc ];

  patchPhase = ''
    rm youtube-dl
  '';

  configurePhase = ''
    makeFlagsArray=( PREFIX=$out SYSCONFDIR=$out/etc PYTHON=${python}/bin/python )
  '';

  postInstall = ''
    # ffmpeg is used for post-processing and fixups
    wrapProgram $out/bin/youtube-dl --prefix PATH : "${ffmpeg}/bin"
  '';

  meta = {
    homepage = "http://rg3.github.com/youtube-dl/";
    repositories.git = https://github.com/rg3/youtube-dl.git;
    description = "Command-line tool to download videos from YouTube.com and other sites";
    license = stdenv.lib.licenses.unlicense;

    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ bluescreen303 simons phreedom AndersonTorres fuuzetsu ];
  };
}
