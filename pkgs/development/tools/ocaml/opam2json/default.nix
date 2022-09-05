{ lib, stdenv, fetchFromGitHub, opam-installer, ocamlPackages }:
stdenv.mkDerivation rec {
  pname = "opam2json";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
    sha256 = "fe8bm/V/4r2iNxgbitT2sXBqDHQ0GBSnSUSBg/1aXoI=";
  };

  buildInputs = with ocamlPackages; [ yojson opam-file-format cmdliner ];
  nativeBuildInputs = with ocamlPackages; [ ocaml findlib opam-installer ];

  preInstall = ''export PREFIX="$out"'';

  meta = with lib; {
    platforms = platforms.all;
    description = "convert opam file syntax to JSON";
    maintainers = [ maintainers.balsoft ];
    license = licenses.gpl3;
    homepage = "https://github.com/tweag/opam2json";
  };
}
