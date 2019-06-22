{ stdenv, lib, bundlerApp, makeWrapper
, ffmpeg, handbrake, mkvtoolnix-cli, mp4v2
}:

bundlerApp rec {
  pname = "video_transcoding";
  gemdir = ./.;
  exes = [
    "convert-video"
    "detect-crop"
    "query-handbrake-log"
    "transcode-video"
  ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/convert-video --prefix PATH : \
      ${lib.makeBinPath [ ffmpeg handbrake mkvtoolnix-cli mp4v2 ]}
    wrapProgram $out/bin/detect-crop --prefix PATH : \
      ${lib.makeBinPath [ ffmpeg handbrake ]}
    wrapProgram $out/bin/transcode-video --prefix PATH : \
      ${lib.makeBinPath [ ffmpeg handbrake mkvtoolnix-cli mp4v2 ]}
  '';

  meta = with lib; {
    description = "Tools to transcode, inspect and convert videos";
    homepage    = https://github.com/donmelton/video_transcoding;
    license     = licenses.mit;
    maintainers = [ maintainers.bdesham ];
    platforms   = platforms.all;
  };
}
