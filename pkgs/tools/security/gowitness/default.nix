{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gowitness";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = pname;
    rev = version;
    sha256 = "sha256-37OorjzxDu27FNAz4LTtQdFjt0tL9jSb9tGZhlq797Q=";
  };

  vendorHash = "sha256-Exw5NfR3nDYH+hWMPOKuVIRyrVkOJyP7Kwe4jzQwnsI=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
