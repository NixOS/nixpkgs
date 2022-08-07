{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-phnPs9mpheIOP0uZZ1Uoo7oRXl09Z+0q54v16YUYNUc=";
  };

  vendorSha256 = "sha256-Ohdl99h/5epbONaYeGSC02evWcGe+8FtZ53RXHHsMpg=";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
