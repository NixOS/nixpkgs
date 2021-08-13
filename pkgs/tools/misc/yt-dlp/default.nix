{ lib, fetchPypi, buildPythonPackage
, zip, ffmpeg, rtmpdump, phantomjs2, atomicparsley, pycryptodome, pandoc
, websockets, mutagen
, ffmpegSupport ? true
, rtmpSupport ? true
, phantomjsSupport ? false
, hlsEncryptedSupport ? true
, installShellFiles, makeWrapper }:

buildPythonPackage rec {
  pname = "yt-dlp";
  version = "2021.08.10";

  src = fetchPypi {
    inherit pname;
    version = with lib; concatMapStringsSep "." (removePrefix "0") (with versions; [(major version) (minor version) (patch version)]);
    sha256 = "0h2jybl39mfiv5qd5q6mm8y3ks4y221lfg246z8kf7b4qi6vz8cd";
  };

  # build_lazy_extractors assumes this directory exists
  # but it is not present in the pypi package
  postPatch = ''
    mkdir -p ytdlp_plugins/extractor
  '';

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  buildInputs = [ zip pandoc ];
  propagatedBuildInputs = [ websockets mutagen ]
    ++ lib.optional hlsEncryptedSupport pycryptodome;

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs = let
      packagesToBinPath = [ atomicparsley ]
        ++ lib.optional ffmpegSupport ffmpeg
        ++ lib.optional rtmpSupport rtmpdump
        ++ lib.optional phantomjsSupport phantomjs2;
    in [ ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"'' ];

  setupPyBuildFlags = [
    "build_lazy_extractors"
  ];

  # Requires network
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/yt-dlp/yt-dlp/";
    description = "Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)";
    longDescription = ''
      yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc.

      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
    license = licenses.publicDomain;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
