{ lib
, fetchFromGitHub
, ocamlPackages
, pkg-config
, libdrm
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "unstable-2022-09-22";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "5940346db2a4427f21c7b30a2593b179af36a935";
    sha256 = "0jnr5q52nb3yqr7ykvvb902xsad24cdi9imkslcsa5cnzb4095rw";
  };

  postPatch = ''
    # no need to vendor
    rm -r ocaml-wayland
  '';

  minimalOCamlVersion = "4.12";

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ libdrm ] ++ (with ocamlPackages; [
    dune-configurator
    ppx_cstruct
    wayland
    cmdliner
    logs
    cstruct-lwt
    ppx_cstruct
  ]);

  doCheck = true;

  meta = {
    homepage = "https://github.com/talex5/wayland-virtwl-proxy";
    description = "Proxy Wayland connections across a VM boundary";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
