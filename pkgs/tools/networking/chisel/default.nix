{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "chisel";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "jpillora";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-N2voSclNH7lGbUkZo2gkrEb6XoA5f0BzNgAzQs1lOKQ=";
  };

  vendorHash = "sha256-p/5g4DLoUhEPFBtAbMiIgc6O4eAfbiqBjCqYkyUHy70=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/jpillora/chisel/share.BuildVersion=${version}"
  ];

  # Tests require access to the network
  doCheck = false;

  meta = with lib; {
    description = "TCP/UDP tunnel over HTTP";
    longDescription = ''
      Chisel is a fast TCP/UDP tunnel, transported over HTTP, secured via
      SSH. Single executable including both client and server. Chisel is
      mainly useful for passing through firewalls, though it can also be
      used to provide a secure endpoint into your network.
    '';
    homepage = "https://github.com/jpillora/chisel";
    changelog = "https://github.com/jpillora/chisel/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
