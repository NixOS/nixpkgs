{ stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation rec {
  version = "0.3.1";
  name = "opaline-${version}";

  src = fetchFromGitHub {
    owner = "jaapb";
    repo = "opaline";
    rev = "v${version}";
    sha256 = "0vd5xaf272hk4iqfj347jvbppy7my5p5gz8yqpkvl1d1i6lzh08v";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib ocamlbuild opam-file-format ];

  preInstall = "mkdir -p $out/bin";

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "OPAm Light INstaller Engine";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
