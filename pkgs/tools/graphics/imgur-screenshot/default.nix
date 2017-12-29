{ stdenv, fetchFromGitHub, makeWrapper, curl, gnugrep, libnotify, scrot, which, xclip }:

let deps = stdenv.lib.makeBinPath [ curl gnugrep libnotify scrot which xclip ];
in stdenv.mkDerivation rec {
  version = "1.7.1";
  name = "imgur-screenshot-${version}";

  src = fetchFromGitHub {
    owner = "jomo";
    repo = "imgur-screenshot";
    rev = "v${version}";
    sha256 = "01wiqrc7xxvk7kzgw756jahwa0szb200l8030iwfcgxb679k3v0j";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 imgur-screenshot.sh $out/bin/imgur-screenshot
    wrapProgram $out/bin/imgur-screenshot --prefix PATH ':' ${deps}
  '';

  meta = with stdenv.lib; {
    description = "A tool for easy screencapping and uploading to imgur";
    homepage = https://https://github.com/jomo/imgur-screenshot/;
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ lw ];
  };
}
