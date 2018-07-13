{ stdenv, fetchFromGitHub, lib, ocaml, libelf, cf-private, CoreServices,
  findlib, camlp4, sedlex, ocamlbuild, lwt_ppx, wtf8, dtoa }:

with lib;

stdenv.mkDerivation rec {
  version = "0.76.0";
  name = "flow-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "0r3yl4m7dhm1h4c431zp8hd2gg6k1d9bwd2371xav5q7hviwmjl6";
  };

  # lwt.log is being split out into a separate package, so this can be
  # removed once nixpkgs is updated.
  # See https://github.com/ocsigen/lwt/issues/453#issuecomment-352897664
  postPatch = ''
    substituteInPlace Makefile --replace lwt_log lwt.log
  '';

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
