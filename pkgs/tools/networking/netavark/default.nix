{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, mandown
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M0jsCwle57YM0RO1hGMju5+8XvHPWc8tJqKWJL/sFsg=";
  };

  cargoHash = "sha256-zTgHjDZdsseUpB5Xqn9yE5T6Tgqx22pQKQLlUtZq+lc=";

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
