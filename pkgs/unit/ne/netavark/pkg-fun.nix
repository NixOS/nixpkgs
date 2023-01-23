{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, mandown
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nG+HTwF3v8FUK2SE+I312Ec5y6YPShS9si9Pc2SG1jc=";
  };

  cargoHash = "sha256-szIG1udBCZj18sN3IiQtOuR8qw/xWhTMgb/n4lyTwvs=";

  nativeBuildInputs = [ installShellFiles mandown ];

  postBuild = ''
    make -C docs netavark.1
    installManPage docs/netavark.1
  '';

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
