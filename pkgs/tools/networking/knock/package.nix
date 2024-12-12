{
  lib,
  buildGoModule,
  fetchFromGitea,
  installShellFiles,
}:

buildGoModule rec {
  pname = "knock";
  version = "0.0.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "nat-418";
    repo = "knock";
    rev = "v${version}";
    hash = "sha256-K+L4F4bTERQSqISAmfyps/U5GJ2N0FdJ3RmpiUmt4uA=";
  };

  vendorHash = "sha256-wkSXdIgfkHbVJYsgm/hLAeKA9geof92U3mzSzt7eJE8=";

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/man1/knock.1
  '';

  meta = with lib; {
    description = "Simple CLI network reachability tester";
    homepage = "https://codeberg.org/nat-418/knock";
    license = licenses.bsd0;
    changelog = "https://codeberg.org/nat-418/knock/raw/branch/trunk/CHANGELOG.md";
    maintainers = with maintainers; [ nat-418 ];
  };
}
