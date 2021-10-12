{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scilla";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xg8qnpYRdSGaFkjmQLbjMFIU419ASEHtFA8h8ads/50=";
  };

  vendorSha256 = "sha256-PFfzlqBuasTNeCNnu5GiGyQzBQkbe83q1EqCsWTor18=";

  meta = with lib; {
    description = "Information gathering tool for DNS, ports and more";
    homepage = "https://github.com/edoardottt/scilla";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
