{ stdenv, fetchurl, python, zip, pandoc }:

let
  version = "2014.12.17.2";
in
stdenv.mkDerivation rec {
  name = "youtube-dl-${version}";

  src = fetchurl {
    url = "http://youtube-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "1yk8dw0p4nh68p4rcncwl95gcjwn147wyp2anfhn0gr8b95wcb1h";
  };

  buildInputs = [ python ];
  nativeBuildInputs = [ zip pandoc ];

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
    maintainers = with stdenv.lib.maintainers; [ bluescreen303 simons phreedom AndersonTorres fuuzetsu ];
  };
}
