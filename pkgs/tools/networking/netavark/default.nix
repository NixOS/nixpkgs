{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  mandown,
  protobuf,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-amvy8sR2gpTYU7wcfkFeYyaTvrhZC558zidNdHwxqaI=";
  };

  cargoHash = "sha256-v8djyU+MvBmg929oFVPZlRPtj7zK8eZg3/KmCsFNWpw=";

  nativeBuildInputs = [
    installShellFiles
    mandown
    protobuf
  ];

  postBuild = ''
    make -C docs netavark.1
    installManPage docs/netavark.1
  '';

  passthru.tests = {
    inherit (nixosTests) podman;
  };

  meta = with lib; {
    changelog = "https://github.com/containers/netavark/releases/tag/${src.rev}";
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
