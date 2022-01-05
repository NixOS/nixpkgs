{ lib, fetchurl, fetchpatch, buildPythonPackage
, zip, ffmpeg, rtmpdump, phantomjs2, atomicparsley, pycryptodome, pandoc
# Pandoc is required to build the package's man page. Release tarballs contain a
# formatted man page already, though, it will still be installed. We keep the
# manpage argument in place in case someone wants to use this derivation to
# build a Git version of the tool that doesn't have the formatted man page
# included.
, generateManPage ? false
, ffmpegSupport ? true
, rtmpSupport ? true
, phantomjsSupport ? false
, hlsEncryptedSupport ? true
, installShellFiles, makeWrapper }:

buildPythonPackage rec {

  pname = "youtube-dl";
  # The websites youtube-dl deals with are a very moving target. That means that
  # downloads break constantly. Because of that, updates should always be backported
  # to the latest stable release.
  version = "2021.12.17";

  src = fetchurl {
    url = "https://yt-dl.org/downloads/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-nzuZyLd4RVFltFJfIVBehsf/Vl86wxnhlzPYEBlBNd8=";
  };

  patches = [
    # Fixes throttling on youtube.com. Without the patch downloads are capped at
    # about 80KiB/s. See, e.g.,
    #
    #   https://github.com/ytdl-org/youtube-dl/issues/29326
    #
    # The patch comes from PR https://github.com/ytdl-org/youtube-dl/pull/30188
    (fetchpatch {
      name = "fix-youtube-dl-speed.patch";
      url = "https://github.com/ytdl-org/youtube-dl/pull/30188.patch";
      sha256 = "15liban37ina2y4bnykfdywdy4rbkfff2r6vd0kqn2k7rfkcczyz";
    })
  ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  buildInputs = [ zip ] ++ lib.optional generateManPage pandoc;
  propagatedBuildInputs = lib.optional hlsEncryptedSupport pycryptodome;

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs = let
      packagesToBinPath =
        [ atomicparsley ]
        ++ lib.optional ffmpegSupport ffmpeg
        ++ lib.optional rtmpSupport rtmpdump
        ++ lib.optional phantomjsSupport phantomjs2;
    in [ ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"'' ];

  setupPyBuildFlags = [
    "build_lazy_extractors"
  ];

  postInstall = ''
    installShellCompletion youtube-dl.zsh
  '';

  # Requires network
  doCheck = false;

  meta = with lib; {
    homepage = "https://ytdl-org.github.io/youtube-dl/";
    description = "Command-line tool to download videos from YouTube.com and other sites";
    longDescription = ''
      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
    license = licenses.publicDomain;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ bluescreen303 AndersonTorres fpletz ma27 ];
  };
}
