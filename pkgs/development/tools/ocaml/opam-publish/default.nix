{ lib, fetchFromGitHub, ocamlPackages }:

with ocamlPackages;

buildDunePackage rec {
  pname = "opam-publish";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "ocaml-opam";
    repo = pname;
    rev = version;
    sha256 = "sha256-CiZOljFBUUC3ExGSzzTATGqmxKjbzjRlL4aaL/fx9zI=";
  };

  duneVersion = "3";

  buildInputs = [
    cmdliner
    lwt_ssl
    opam-core
    opam-format
    opam-state
    github
    github-unix
  ];

  meta = with lib; {
    homepage = "https://github.com/ocaml-opam/${pname}";
    description = "A tool to ease contributions to opam repositories";
    license = with licenses; [ lgpl21Only ocamlLgplLinkingException ];
    maintainers = with maintainers; [ niols ];
  };
}
