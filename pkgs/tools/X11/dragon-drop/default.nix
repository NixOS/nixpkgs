{ lib, stdenv, gtk, pkg-config, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dragon-drop";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "mwh";
    repo = "dragon";
    rev = "v${version}";
    sha256 = "0fgzz39007fdjwq72scp0qygp2v3zc5f1xkm0sxaa8zxm25g1bra";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk ];

  installPhase = ''
    install -D dragon -t $out/bin
  '';

  meta = with lib; {
    description = "Simple drag-and-drop source/sink for X";
    homepage = "https://github.com/mwh/dragon";
    maintainers = with maintainers; [ jb55 markus1189 ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
