{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scilla";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8ZRYgQ4xME71vlO0nKnxiCqeju0G4SwgEXnUol1jQxk=";
  };

  vendorSha256 = "sha256-Y4Zi0Hy6ydGxLTohgJGF3L9O+79z+3t+4ZA64otCJpE=";

  meta = with lib; {
    description = "Information gathering tool for DNS, ports and more";
    homepage = "https://github.com/edoardottt/scilla";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
