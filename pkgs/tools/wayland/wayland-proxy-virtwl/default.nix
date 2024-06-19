{ lib
, fetchFromGitHub
, ocamlPackages
, pkg-config
, libdrm
, unstableGitUpdater
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "0-unstable-2024-04-08";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "57dea8de065f5a155d97a32a929bbb2b1ba6b53a";
    sha256 = "sha256-mp/Y13MwdKo7f3E9S0Pnvb3Cb4d6szkIQOFteMrVxCk=";
  };

  minimalOCamlVersion = "5.0";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ libdrm ] ++ (with ocamlPackages; [
    dune-configurator
    eio_main
    ppx_cstruct
    wayland
    cmdliner
    logs
    ppx_cstruct
  ]);

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/talex5/wayland-virtwl-proxy";
    description = "Proxy Wayland connections across a VM boundary";
    license = licenses.asl20;
    mainProgram = "wayland-proxy-virtwl";
    maintainers = [ maintainers.qyliss maintainers.sternenseemann ];
    platforms = platforms.linux;
  };
}
