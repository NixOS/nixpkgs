{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, mandown
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2ElEhKit/XysRsUw+dg7SnhDl+Zf+FJb5pIYpq1ALNs=";
  };

  cargoHash = "sha256-w3qz4ygjIvn+Rxd1JEVO6Ax08leuuJvC4Bk7VygbBh4=";

  nativeBuildInputs = [ installShellFiles mandown ];

  postBuild = ''
    make -C docs
    installManPage docs/*.1
  '';

  meta = with lib; {
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
