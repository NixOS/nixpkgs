{ stdenv, lib, fetchFromGitHub, pythonPackages, makeWrapper, ffmpeg_3 }:

pythonPackages.buildPythonApplication {

  pname = "togglesg-download-git";
  version = "2017-12-07";

  src = fetchFromGitHub {
    owner  = "0x776b7364";
    repo   = "toggle.sg-download";
    rev    = "e64959f99ac48920249987a644eefceee923282f";
    sha256 = "0j317wmyzpwfcixjkybbq2vkg52vij21bs40zg3n1bs61rgmzrn8";
  };

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/doc/togglesg-download}
    substitute $src/download_toggle_video2.py $out/bin/download_toggle_video2.py \
      --replace "ffmpeg_download_cmd = 'ffmpeg" "ffmpeg_download_cmd = '${lib.getBin ffmpeg_3}/bin/ffmpeg"
    chmod 0755 $out/bin/download_toggle_video2.py

    cp LICENSE README.md $out/share/doc/togglesg-download

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/0x776b7364/toggle.sg-download";
    description = "Command-line tool to download videos from toggle.sg written in Python";
    longDescription = ''
      toggle.sg requires SilverLight in order to view videos. This tool will
      allow you to download the video files for viewing in your media player and
      on your OS of choice.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
