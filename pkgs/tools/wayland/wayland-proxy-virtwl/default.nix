{ lib
, fetchFromGitHub
, ocamlPackages
, pkg-config
, libdrm
, unstableGitUpdater
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "unstable-2023-11-28";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "1135a2781c37decce9bc5c566a54d8fbffe8aa73";
    sha256 = "sha256-I3lHB1Y7z/6oNmL2vO/AWaOnpcks7WmqGOdaYtYdxn4=";
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
