{ stdenv, fetchurl, makeWrapper, python, zip, pandoc, ffmpeg }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "youtube-dl-${version}";
  version = "2015.05.20";

  src = fetchurl {
    url = "http://youtube-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "1crfada7vq3d24062wr06sfam66cf14j06wnhg7w5ljzrbynvpll";
  };

  buildInputs = [ python makeWrapper zip pandoc ];

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
    longDescription = ''
      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
    license = licenses.publicDomain;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ bluescreen303 simons phreedom AndersonTorres fuuzetsu ];
  };
}
