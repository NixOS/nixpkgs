{ stdenv, pkgs, fetchFromGitHub }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "tiv-${version}";
  version = "2020-04-09";

  src = fetchFromGitHub {
    owner = "stefanhaustein";
    repo = "TerminalImageViewer";
    rev = "f78b65c1f375e688c7500f644a1766e48b783933";
    sha256 = "055qf1fpapvrckkwlx1zsy1z4dyr87zjj79l7z6vh7d54fs4alpv";
  };

  nativeBuildInputs = with pkgs; [gnumake gcc];
  buildInputs = with pkgs; [imagemagick];
  phases = ["unpackPhase" "buildPhase" "installPhase"];
  buildPhase = ''make -C src/main/cpp'';
  installPhase = ''
    mkdir -p "$out/bin/"
    cp -a src/main/cpp/tiv "$out/bin/"
  '';

  meta = {
    license = licenses.asl20;
    homepage = "https://github.com/stefanhaustein/TerminalImageViewer";
    description = "Small C++ program to display images in a (modern) terminal using RGB ANSI codes and unicode 4x8 block graphic characters.";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
