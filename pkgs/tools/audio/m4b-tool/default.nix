{ fetchurl
, makeWrapper
, mp4v2
, php
, stdenv
, # By default m4b-tool will try to use the lbfdk_aac encoder (which cannot
  # be built by default with ffmpeg due to licensing) but will fall back to
  # ffmpeg's own aac encoder and issue a warning about the resulting audio
  # quality. To silence this warning override ffmpeg with fdk-enabled ffmpeg
  # e.g. ffmpeg-full.override { fdkaacExtlib = true; nonfreeLicensing = true; }
  ffmpeg
, fdkAacSupport ? true
, fdk-aac-encoder
,
}:

stdenv.mkDerivation rec {
  pname = "m4b-tool";
  version = "0.4.2";

  src = fetchurl {
    url = "https://github.com/sandreas/m4b-tool/releases/download/v.${version}/m4b-tool.phar";
    sha256 = "36b40a4867883688605597133f2055bb95ec964ff51be7bd30a3d18b25511e94";
  };

  buildInputs = [ makeWrapper ];

  dontUnpack = true;

  propagatedBuildInputs = [ ffmpeg mp4v2 ]
    ++ stdenv.lib.optional fdkAacSupport fdk-aac-encoder;

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/m4b-tool/m4b-tool.phar
    makeWrapper ${php}/bin/php $out/bin/m4b-tool \
    --add-flags "$out/libexec/m4b-tool/m4b-tool.phar" \
    --set PATH "${fdk-aac-encoder}/bin/:$PATH"
  '';

  meta = with stdenv.lib; {
    description = "A command line utility to merge, split and chapterize audiobook files such as mp3, ogg, flac, m4a or m4b";
    license = licenses.mit;
    homepage = "https://github.com/sandreas/m4b-tool";
    maintainers = [ maintainers.lunik1 ] ++ teams.php.members;
  };
}
