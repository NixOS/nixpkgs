{ stdenv, fetchurl, python, zip }:

let
  version = "2014.10.13";
in
stdenv.mkDerivation rec {
  name = "youtube-dl-${version}";

  src = fetchurl {
    url = "http://youtube-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "0nvcdshsqky3dcyypp86bix0iam7v5hmpl0fy817qwndyi8s0djd";
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
    license = stdenv.lib.licenses.unlicense;

    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ bluescreen303 simons phreedom ];
  };
}
