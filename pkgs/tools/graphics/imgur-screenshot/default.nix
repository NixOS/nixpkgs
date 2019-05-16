{ stdenv, fetchFromGitHub, makeWrapper, curl, gnugrep, libnotify, scrot, which, xclip }:

let deps = stdenv.lib.makeBinPath [ curl gnugrep libnotify scrot which xclip ];
in stdenv.mkDerivation rec {
  version = "1.7.4";
  name = "imgur-screenshot-${version}";

  src = fetchFromGitHub {
    owner = "jomo";
    repo = "imgur-screenshot";
    rev = "v${version}";
    sha256 = "1bhi9sk8v7szh2fj13qwvdwzy5dw2w4kml86sy1ns1rn0xin0cgr";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 imgur-screenshot.sh $out/bin/imgur-screenshot
    wrapProgram $out/bin/imgur-screenshot --prefix PATH ':' ${deps}
  '';

  meta = with stdenv.lib; {
    description = "A tool for easy screencapping and uploading to imgur";
    homepage = https://github.com/jomo/imgur-screenshot/;
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ lw ];
  };
}
