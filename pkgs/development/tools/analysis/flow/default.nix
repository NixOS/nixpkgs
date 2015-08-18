{ stdenv, fetchFromGitHub, ocaml, libelf }:

stdenv.mkDerivation rec {
  version = "0.14.0";
  name = "flow-${version}";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "02adbn2h5bfc4drcpbalq7acx573a657ik3008fr8s9qyqdp2nl6";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [ ocaml libelf ];

  meta = with stdenv.lib; {
    homepage = "http://flowtype.org/";
    description = "A static type checker for JavaScript";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
