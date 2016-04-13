{ stdenv, fetchFromGitHub, buildPythonApplication, makeWrapper, ffmpeg }:

buildPythonApplication rec {

  name = "togglesg-download-git-${version}";
  version = "2016-02-08";

  src = fetchFromGitHub {
    owner = "0x776b7364";
    repo = "toggle.sg-download";
    rev = "5cac3ec039d67ad29240b2fa850a8db595264e3d";
    sha256 = "0pqw73aa5b18d5ws4zj6gcmzap6ag526jrylqq80m0yyh9yxw5hs";
  };

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m755 download_toggle_video2.py $out/bin/download_toggle_video2.py
  '';

  postInstall = stdenv.lib.optionalString (ffmpeg != null)
    ''wrapProgram $out/bin/download_toggle_video2.py --prefix PATH : "${ffmpeg}/bin"'';

  meta = with stdenv.lib; {
    homepage = "https://github.com/0x776b7364/toggle.sg-download";
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
