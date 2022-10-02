{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, mandown
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-72ft1VZVv6Wxfr3RsJMOVl1Z0KMVGgCsUHKGH+filzg=";
  };

  cargoHash = "sha256-FboPbOjkGRzOeoXrIkl1l2BXeid4AOiwxCJ6wlGQ66g=";

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
