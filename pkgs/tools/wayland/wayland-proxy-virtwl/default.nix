{ lib
, fetchFromGitHub
, ocamlPackages
, pkg-config
, libdrm
, unstableGitUpdater
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "unstable-2023-10-27";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "cc9548c4980ff33f86d5645ce337a79bf95d6139";
    sha256 = "sha256-aAqbPslTu+RLQPKPJQH2iYjcI8/De2WPk5nHULdfocU=";
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
