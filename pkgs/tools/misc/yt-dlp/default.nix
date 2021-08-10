{ lib, fetchurl, buildPythonPackage
, zip, ffmpeg, rtmpdump, phantomjs2, atomicparsley, pycryptodome, pandoc
, fetchFromGitHub
, websockets, mutagen
, ffmpegSupport ? true
, rtmpSupport ? true
, phantomjsSupport ? false
, hlsEncryptedSupport ? true
, installShellFiles, makeWrapper }:

buildPythonPackage rec {
  pname = "yt-dlp";
  # The websites yt-dlp deals with are a very moving target. That means that
  # downloads break constantly. Because of that, updates should always be backported
  # to the latest stable release.
  version = "2021.07.21";

  src = fetchFromGitHub {
    owner = "yt-dlp";
    repo = "yt-dlp";
    rev = version;
    sha256 = "ziOW52LJUBe0j7ru8GYgiUCE6YJeBTTjm+H6W8EZjuY=";
  };

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
