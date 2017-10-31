{ stdenv, lib, fetchFromGitHub, pythonPackages, makeWrapper, ffmpeg_3 }:

pythonPackages.buildPythonApplication rec {

  name = "togglesg-download-git-${version}";
  version = "2016-05-31";

  src = fetchFromGitHub {
    owner = "0x776b7364";
    repo = "toggle.sg-download";
    rev = "7d7c5f4d549360f95e248accd9771949abd94ad2";
    sha256 = "0xj42khvacwmhbiy2p8rxk7lqg7pvya4zdc2c34lnr3avdp49fjn";
  };

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    substitute $src/download_toggle_video2.py $out/bin/download_toggle_video2.py \
      --replace "ffmpeg_download_cmd = 'ffmpeg" "ffmpeg_download_cmd = '${lib.getBin ffmpeg_3}/bin/ffmpeg"
    chmod 0755 $out/bin/download_toggle_video2.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/0x776b7364/toggle.sg-download;
    description = "Command-line tool to download videos from toggle.sg written in Python";
    longDescription = ''
      toggle.sg requires SilverLight in order to view videos. This tool will
      allow you to download the video files for viewing in your media player and
      on your OS of choice.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.peterhoeg ];
  };
}
