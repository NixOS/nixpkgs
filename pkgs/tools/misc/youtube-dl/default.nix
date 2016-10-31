{ stdenv, fetchurl, buildPythonApplication, makeWrapper, zip, ffmpeg, pandoc
, atomicparsley
# Pandoc is required to build the package's man page. Release tarballs contain a
# formatted man page already, though, it will still be installed. We keep the
# manpage argument in place in case someone wants to use this derivation to
# build a Git version of the tool that doesn't have the formatted man page
# included.
, generateManPage ? false
, ffmpegSupport ? true
}:

with stdenv.lib;

buildPythonApplication rec {

  name = "youtube-dl-${version}";
  version = "2016.10.31";

  src = fetchurl {
    url = "https://yt-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "b8a0889bf4fed2f54d8ebbc6ea7860feae05b122d1b192417af68159b83f0bb4";
  };

  buildInputs = [ makeWrapper zip ] ++ optional generateManPage pandoc;

  # Ensure ffmpeg is available in $PATH for post-processing & transcoding support.
  # atomicparsley for embedding thumbnails
  postInstall = let
    packagesthatwillbeusedbelow = [ atomicparsley ] ++ optional ffmpegSupport ffmpeg;
  in ''
    wrapProgram $out/bin/youtube-dl --prefix PATH : "${makeBinPath packagesthatwillbeusedbelow}"
  '';

  # Requires network
  doCheck = false;

  meta = {
    homepage = http://rg3.github.io/youtube-dl/;
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
    maintainers = with maintainers; [ bluescreen303 phreedom AndersonTorres fuuzetsu ];
  };
}
