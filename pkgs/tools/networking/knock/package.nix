{ lib, buildGoModule, installShellFiles, fetchFromGitHub }:

buildGoModule rec {
  pname = "knock";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "nat-418";
    repo = pname;
    rev = "a3749685381cae178bb5836c67645e0fce7aa1d0";
    hash = "sha256-VXrWphfBDGDNsz4iuUdwwd46oqnmhJ9i3TtzMqHoSJk=";
  };

  vendorHash = "sha256-wkSXdIgfkHbVJYsgm/hLAeKA9geof92U3mzSzt7eJE8=";

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/man1/knock.1
  '';

  meta = with lib; {
    description = "A simple CLI network reachability tester";
    homepage = "https://github.com/nat-418/knock";
    license = licenses.bsd0;
    changelog = "https://github.com/nat-418/knock/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ nat-418 ];
  };
}
