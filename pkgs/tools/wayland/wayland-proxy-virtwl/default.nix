{ lib
, fetchFromGitHub
, ocamlPackages
, pkg-config
, libdrm
, unstableGitUpdater
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "unstable-2023-12-09";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "ec052fa0e9ae2b2926afc27e23a50b4d3072e6ac";
    sha256 = "sha256-ZWW44hfWs0F4SwwEjx62o/JnuXSrSlq2lrRFRTuPUFE=";
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
