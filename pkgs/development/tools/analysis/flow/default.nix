{ stdenv, fetchFromGitHub, lib, ocamlPackages, libelf, cf-private, CoreServices }:

with lib;

stdenv.mkDerivation rec {
  version = "0.77.0";
  name = "flow-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "1wcbqw5vwb3wsz9dkhi2k159ms98kn1nw3g9lc2j9w1m8ki41lql";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [ libelf
  ] ++ (with ocamlPackages; [
    ocaml findlib camlp4 sedlex ocamlbuild lwt_ppx ppx_deriving ppx_gen_rec lwt_log wtf8 dtoa
  ]) ++ optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = http://flowtype.org;
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
