{ lib, fetchurl, buildPythonPackage
, zip, ffmpeg, rtmpdump, phantomjs2, atomicparsley, pycryptodome, pandoc
, fetchpatch
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
, makeWrapper }:

buildPythonPackage rec {

  pname = "youtube-dl";
  version = "2018.09.01";

  src = fetchurl {
    url = "https://yt-dl.org/downloads/${version}/${pname}-${version}.tar.gz";
    sha256 = "0h8x8agl4s5cnfzwmshbcg4pxcgg3iyb86w8krs21y2k9d1ng036";
  };

  patches = [
    # https://github.com/rg3/youtube-dl/pull/17464
    (fetchpatch {
      name = "youtube-js-player-fix.patch";
      url = "https://github.com/rg3/youtube-dl/pull/17464/commits/6d7359775ae4eef1d1213aae81e092467a2c675c.patch";
      sha256 = "12mwfmp7iwlawpx6r4rhz546b3anxrx6zc4nyjs8grbh5vxhj9yg";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ zip ] ++ lib.optional generateManPage pandoc;
  propagatedBuildInputs = lib.optional hlsEncryptedSupport pycryptodome;

  # Ensure ffmpeg is available in $PATH for post-processing & transcoding support.
  # rtmpdump is required to download files over RTMP
  # atomicparsley for embedding thumbnails
  makeWrapperArgs = let
      packagesToBinPath =
        [ atomicparsley ]
        ++ lib.optional ffmpegSupport ffmpeg
        ++ lib.optional rtmpSupport rtmpdump
        ++ lib.optional phantomjsSupport phantomjs2;
    in [ ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"'' ];

  postInstall = ''
    mkdir -p $out/share/zsh/site-functions
    cp youtube-dl.zsh $out/share/zsh/site-functions/_youtube-dl
  '';

  # Requires network
  doCheck = false;

  meta = with lib; {
    homepage = https://rg3.github.io/youtube-dl/;
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
    maintainers = with maintainers; [ bluescreen303 phreedom AndersonTorres fuuzetsu fpletz enzime ];
  };
}
