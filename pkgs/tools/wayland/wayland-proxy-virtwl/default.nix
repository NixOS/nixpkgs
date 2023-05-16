{ lib
, fetchFromGitHub
, ocamlPackages
, pkg-config
, libdrm
<<<<<<< HEAD
, unstableGitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
<<<<<<< HEAD
  version = "unstable-2023-08-13";
=======
  version = "unstable-2022-09-22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
<<<<<<< HEAD
    rev = "050c49a377808105b895e81e7e498f35cc151e58";
    sha256 = "sha256-6YJv3CCED6LUSPFwYQyHUFkkvOWZGPNHVzw60b5F8+c=";
  };

=======
    rev = "5940346db2a4427f21c7b30a2593b179af36a935";
    sha256 = "0jnr5q52nb3yqr7ykvvb902xsad24cdi9imkslcsa5cnzb4095rw";
  };

  postPatch = ''
    # no need to vendor
    rm -r ocaml-wayland
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru.updateScript = unstableGitUpdater { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/talex5/wayland-virtwl-proxy";
    description = "Proxy Wayland connections across a VM boundary";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = [ maintainers.qyliss maintainers.sternenseemann ];
=======
    maintainers = [ maintainers.sternenseemann ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
