{ stdenv, fetchurl, makeWrapper, buildPythonPackage, zip, ffmpeg
, pandoc ? null }:

# Pandoc is required to build the package's man page. Release tarballs
# contain a formatted man page already, though, so it's fine to pass
# "pandoc = null" to this derivation; the man page will still be
# installed. We keep the pandoc argument and build input in place in
# case someone wants to use this derivation to build a Git version of
# the tool that doesn't have the formatted man page included.

buildPythonPackage rec {
  name = "youtube-dl-${version}";
  version = "2015.08.16.1";

  src = fetchurl {
    url = "http://youtube-dl.org/downloads/${version}/${name}.tar.gz";
    sha256 = "04g78anvy519pj8m8ys1ifmnmp1x3i9bw3afwqjch71n9f77papy";
  };

  buildInputs = [ makeWrapper zip pandoc ];

  # Ensure ffmpeg is available in $PATH for post-processing & transcoding support.
  postInstall = stdenv.lib.optionalString (ffmpeg != null)
    ''wrapProgram $out/bin/youtube-dl --prefix PATH : "${ffmpeg}/bin"'';

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
