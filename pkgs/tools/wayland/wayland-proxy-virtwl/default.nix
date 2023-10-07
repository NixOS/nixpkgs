{ lib
, fetchFromGitHub
, ocamlPackages
, pkg-config
, libdrm
, unstableGitUpdater
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "unstable-2023-08-13";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "050c49a377808105b895e81e7e498f35cc151e58";
    sha256 = "sha256-6YJv3CCED6LUSPFwYQyHUFkkvOWZGPNHVzw60b5F8+c=";
  };

  minimalOCamlVersion = "4.12";
  duneVersion = "3";

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
