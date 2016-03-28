{ stdenv, fetchFromGitHub, lib, ocaml, libelf, cf-private, CoreServices }:

with lib;

stdenv.mkDerivation rec {
  version = "0.22.0";
  name = "flow-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "1p8a5cf85ydz6g04zsvsa6sh2b4p94mj9cqj7k6llf0dsiihrv54";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [ ocaml libelf ]
    ++ optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = http://flowtype.org;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
