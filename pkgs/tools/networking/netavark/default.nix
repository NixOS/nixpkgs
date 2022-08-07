{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, mandown
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NZt62oTD7yFO1+HTuyp+wEd2PuUwtsIrMPHwjfmz3aI=";
  };

  cargoHash = "sha256-l+y3mkV6uZJed2nuXNWXDr6Q1UhV0YlfRhpE7rvTRrE=";

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
