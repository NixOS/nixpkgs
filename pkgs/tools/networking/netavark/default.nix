{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, mandown
, protobuf
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-amvy8sR2gpTYU7wcfkFeYyaTvrhZC558zidNdHwxqaI=";
  };

  cargoHash = "sha256-v8djyU+MvBmg929oFVPZlRPtj7zK8eZg3/KmCsFNWpw=";
=======
    hash = "sha256-USGmYLBv2ynnLx5jg+WkRle0AMtO7dDgf41VIepoHN0=";
  };

  cargoHash = "sha256-zj1eE7f4/wSVe+78abMePqsIrCPl6Uhtavn8hq7+ZRY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles mandown protobuf ];

  postBuild = ''
    make -C docs netavark.1
    installManPage docs/netavark.1
  '';

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/netavark/releases/tag/${src.rev}";
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
