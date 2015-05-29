{ stdenv, fetchurl, ffmpeg, makeWrapper, pandoc, python, zip }:

stdenv.mkDerivation rec {
  name = "youtube-dl-${version}";
  version = "2015.05.20";

  src = fetchurl {
    url = "http://youtube-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "1crfada7vq3d24062wr06sfam66cf14j06wnhg7w5ljzrbynvpll";
  };

  nativeBuildInputs = [ pandoc ];

  buildInputs = [ python makeWrapper zip ];

  patchPhase = ''
    rm youtube-dl
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc"
    "PYTHON=${python.interpreter}"
  ];

  postInstall = ''
    # Include FFmpeg for post-processing & transcoding support
    # Ensure ffmpeg is available in $PATH for youtube-dl
    wrapProgram $out/bin/youtube-dl --prefix PATH : "${ffmpeg}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Command-line tool to download videos from YouTube.com and other sites";
    homepage = http://rg3.github.com/youtube-dl/;
    repositories.git = https://github.com/rg3/youtube-dl.git;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ AndersonTorres bluescreen303 fuuzetsu phreedom simons ];
    platforms = with platforms; linux ++ darwin;

    longDescription = ''
      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
  };
}
