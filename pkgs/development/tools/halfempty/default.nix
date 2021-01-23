{ lib, stdenv, fetchFromGitHub, pkg-config, glib, util-linux, scowl }:

stdenv.mkDerivation rec {
  pname = "halfempty";
  version = "0.40";

  src = fetchFromGitHub {
    owner = "googleprojectzero";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YGq6fneAMo2jCpLPrjzRJ0eeOsStKaK5L+lwQfqcfpY=";
  };

  nativeBuildInputs = [ pkg-config util-linux ];
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
