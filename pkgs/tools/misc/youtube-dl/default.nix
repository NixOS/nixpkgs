{ stdenv, fetchurl, python, pandoc, zip }:

let
  version = "2012.12.11";
in
stdenv.mkDerivation {
  name = "youtube-dl-${version}";

  src = fetchurl {
    url = "https://github.com/downloads/rg3/youtube-dl/youtube-dl.${version}.tar.gz";
    sha256 = "03zv3z8p0fi122nqj7ff8hkgqscir4s7psm03rq7dfpg1z35klmn";
  };

  buildInputs = [ python ];
  nativeBuildInputs = [ pandoc zip ];

  patchPhase = ''
    rm youtube-dl
    substituteInPlace Makefile --replace "#!/usr/bin/env python" "#!${python}/bin/python"
  '';

  configurePhase = ''
    makeFlagsArray=( PREFIX=$out SYSCONFDIR=$out/etc )
  '';

  meta = {
    homepage = "http://rg3.github.com/youtube-dl/";
    description = "Command-line tool to download videos from YouTube.com and other sites";

    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ bluescreen303 simons ];
  };
}
