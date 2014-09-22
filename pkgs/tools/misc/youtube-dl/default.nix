{ stdenv, fetchurl, python, zip }:

let
  version = "2014.09.19";
in
stdenv.mkDerivation rec {
  name = "youtube-dl-${version}";

  src = fetchurl {
    url = "http://youtube-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "0xyn9rszvv0k0rqgwqzr69bk4n2crfxkwmmi8k26aw52yggba24k";
  };

  buildInputs = [ python ];
  nativeBuildInputs = [ zip ];

  patchPhase = ''
    rm youtube-dl
  '';

  configurePhase = ''
    makeFlagsArray=( PREFIX=$out SYSCONFDIR=$out/etc PYTHON=${python}/bin/python )
  '';

  meta = {
    homepage = "http://rg3.github.com/youtube-dl/";
    repositories.git = https://github.com/rg3/youtube-dl.git;
    description = "Command-line tool to download videos from YouTube.com and other sites";

    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ bluescreen303 simons phreedom ];
  };
}
