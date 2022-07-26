{ lib
, fetchFromGitHub
, ocamlPackages
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "unstable-2021-12-05";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "d7f58d405514dd031f2f12e402c8c6a58e62a885";
    sha256 = "0riwaqdlrx2gzkrb02v4zdl4ivpmz9g5w87lj3bhqs0l3s6c249s";
  };

  postPatch = ''
    # no need to vendor
    rm -r ocaml-wayland
  '';

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  strictDeps = true;
  nativeBuildInputs = [
    ocamlPackages.ppx_cstruct
  ];

  buildInputs = with ocamlPackages; [
    wayland
    cmdliner
    logs
    cstruct-lwt
    ppx_cstruct
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/talex5/wayland-virtwl-proxy";
    description = "Proxy Wayland connections across a VM boundary";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
