{ lib, buildPythonPackage, fetchFromGitHub,
  ffmpegSupport ? false, ffmpeg_4,
  wxPython, gettext, twodict, youtube-dl }:

buildPythonPackage rec {
  pname = "youtube-dl-gui";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "MrS0m30n3";
    repo = "youtube-dl-gui";
    rev = version;
    sha256 = "1znnjd3ks8r5bsdg9k94yjpwcynlif6l4c07lmlby8vkgpgn0hyj";
  };

  preBuild = ''
    export HOME=$NIX_BUILD_TOP
  '';

  propagatedBuildInputs = [ wxPython twodict youtube-dl ];

  nativeBuildInputs = [ gettext ];

  doCheck = false; # tests rely on display

  makeWrapperArgs = lib.optional ffmpegSupport ''--prefix PATH : "${lib.makeBinPath [ ffmpeg_4 ]}"'';

  meta = with lib; {
    description = "A cross platform front-end GUI of the popular youtube-dl written in wxPython";
    homepage = "https://mrs0m30n3.github.io/youtube-dl-gui/";
    license = licenses.unlicense;
    maintainers = with maintainers; [ alexarice ];
  };
}
