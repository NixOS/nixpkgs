{ lib
, fetchFromGitHub
, ocamlPackages
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "unstable-2021-04-15";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "09321a28f3d4c0fa7e41ebb3014106b62090b649";
    sha256 = "03rc2jp5d2y9y7mfis6kk9gchd49gvq0jg6fq5gi9r21ckb4k5v4";
  };

  postPatch = ''
    # no need to vendor
    rm -r ocaml-wayland
  '';

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  buildInputs = with ocamlPackages; [
    wayland
    cmdliner
    logs
  ];

  meta = {
    homepage = "https://github.com/talex5/wayland-virtwl-proxy";
    description = "Proxy Wayland connections across a VM boundary";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
