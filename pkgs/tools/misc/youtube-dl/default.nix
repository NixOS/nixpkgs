{ manuals ? true
, stdenv, fetchurl, makeWrapper, python, zip, 
pandoc ? null 
, ffmpeg }:

assert manuals -> pandoc != null;

stdenv.mkDerivation rec {
  name = "youtube-dl-${version}";
  version = "2015.05.29";

  src = fetchurl {
    url = "http://youtube-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "0lgxir2i5ipplg57wk8gnbbsdrk7szqnyb1bxr97f3h0rbm4dfij";
  };

  nativeBuildInputs = [ ]
    ++ stdenv.lib.optional manuals pandoc;

  buildInputs = [ python makeWrapper zip ];

  patchPhase = ''
    rm youtube-dl
  '';

  configurePhase = ''
    makeFlagsArray=( PREFIX=$out SYSCONFDIR=$out/etc PYTHON=${python}/bin/python )
  '';

  # Ensure ffmpeg is available in $PATH for post-processing & transcoding support.
  postInstall = ''
    wrapProgram $out/bin/youtube-dl --prefix PATH : "${ffmpeg}/bin"
  '';

  meta = with stdenv.lib; {
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
