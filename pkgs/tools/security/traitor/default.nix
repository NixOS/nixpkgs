{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "traitor";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UuWJe4nVr87ab3yskqKxnclMg9EywlcgaM/WOREXD/c=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Automatic Linux privilege escalation";
    longDescription = ''
      Automatically exploit low-hanging fruit to pop a root shell. Traitor packages
      up a bunch of methods to exploit local misconfigurations and vulnerabilities
      (including most of GTFOBins) in order to pop a root shell.
    '';
    homepage = "https://github.com/liamg/traitor";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
