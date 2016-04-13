{ stdenv, fetchFromGitHub, makeWrapper, curl, gnugrep, libnotify, scrot, which, xclip }:

let deps = stdenv.lib.makeBinPath [ curl gnugrep libnotify scrot which xclip ];
in stdenv.mkDerivation rec {
  version = "1.5.4";
  name = "imgur-screenshot-${version}";

  src = fetchFromGitHub {
    owner = "jomo";
    repo = "imgur-screenshot";
    rev = "v${version}";
    sha256 = "1ff88mvrd0b7nmrkjljs3rnprk5ih0iif92dn39s3vnag3fp9f10";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 imgur-screenshot.sh $out/bin/imgur-screenshot
    wrapProgram $out/bin/imgur-screenshot --prefix PATH ':' ${deps}
  '';

  meta = with stdenv.lib; {
    description = "A tool for easy screencapping and uploading to imgur";
    homepage = "https://https://github.com/jomo/imgur-screenshot/";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ lw ];
  };
}
