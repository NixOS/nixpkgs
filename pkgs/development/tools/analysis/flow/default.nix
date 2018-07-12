{ stdenv, fetchFromGitHub, lib, ocamlPackages, libelf, cf-private, CoreServices }:

with lib;

stdenv.mkDerivation rec {
  version = "0.75.0";
  name = "flow-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "0xrcjjk16w6anpy58qa4la1jyfjs0xg5xkp58slhai996wqif24k";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [ libelf
  ] ++ (with ocamlPackages; [
    ocaml findlib camlp4 sedlex ocamlbuild lwt_ppx lwt_log wtf8 dtoa
  ]) ++ optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = http://flowtype.org;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
