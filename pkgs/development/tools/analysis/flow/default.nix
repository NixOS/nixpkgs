{ stdenv, fetchFromGitHub, lib, ocaml, libelf, cf-private, CoreServices,
  findlib, camlp4, sedlex, ocamlbuild, lwt_ppx, wtf8, dtoa }:

with lib;

stdenv.mkDerivation rec {
  version = "0.69.0";
  name = "flow-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "11n8g471zgazcnzsxcw45gzzn63xanw91wj5xwsx8i2cp7wg9g7g";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [
    ocaml libelf findlib camlp4 sedlex ocamlbuild lwt_ppx wtf8 dtoa
  ] ++ optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = http://flowtype.org;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
