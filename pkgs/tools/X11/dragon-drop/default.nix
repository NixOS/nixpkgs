{ stdenv, gtk, pkgconfig, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dragon-drop";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mwh";
    repo = "dragon";
    rev = "v${version}";
    sha256 = "0iwlrcqvbjshpwvg0gsqdqcjv48q1ary59pm74zzjnr8v9470smr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk ];

  installPhase = ''
    mkdir -p $out/bin
    mv dragon $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Simple drag-and-drop source/sink for X";
    homepage = https://github.com/mwh/dragon;
    maintainers = with maintainers; [ jb55 markus1189 ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
