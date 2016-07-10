{ stdenv, fetchFromGitHub, lib, ocaml, libelf, cf-private, CoreServices, git, mercurial }:

with lib;

stdenv.mkDerivation rec {
  version = "0.28.0";
  name = "flow-${version}";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "1xryv1366zc385r82r6n832xkaqcm63zs1baizl02qchfzfa3am2";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [ ocaml libelf git mercurial ] # git and mercurial are necessary because of https://github.com/facebook/flow/issues/1981
    ++ optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = http://flowtype.org;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
