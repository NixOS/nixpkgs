{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6PCZtiXsDQfPZFw3r1n3rwgxigSnWgggHXzZdBT/fxA=";
  };

  vendorHash = "sha256-RnvkEUvL/bQTTTlg0RF0xjjvVniltequNKRD3z0H3O8=";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
