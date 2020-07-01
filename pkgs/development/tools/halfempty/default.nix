{ lib, stdenv, fetchFromGitHub, pkgconfig, glib, utillinux, scowl }:

stdenv.mkDerivation rec {
  pname = "halfempty";
  version = "0.30";

  src = fetchFromGitHub {
    owner = "googleprojectzero";
    repo = pname;
    rev = "v${version}";
    sha256 = "0838pw0ccjvlxmjygzrnppz1fx1a10vjzdgjbxgb4wgpqjr8v6vc";
  };

  nativeBuildInputs = [ pkgconfig utillinux ];
  buildInputs = [ glib ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace test/Makefile \
      --replace '/usr/share/dict/words' '${scowl}/share/dict/words.txt'
  '';

  installPhase = ''
    install -vDt $out/bin halfempty
  '';

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Fast, parallel test case minimization tool";
    homepage = "https://github.com/googleprojectzero/halfempty/";
    maintainers = with lib.maintainers; [ fpletz ];
    license = with lib.licenses; [ asl20 ];
  };
}
