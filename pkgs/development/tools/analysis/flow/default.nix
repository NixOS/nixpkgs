{ stdenv, fetchFromGitHub, lib, ocaml, libelf, cf-private, CoreServices }:

with lib;

stdenv.mkDerivation rec {
  version = "0.33.0";
  name = "flow-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "1m0a4w50x1xx6iii5mdciksmzwlmyd8wjbyaqbf6gr1z7vhzmqwh";
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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
