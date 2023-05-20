{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dontgo403";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "devploit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FmC+VEVZVpKEDV8IH8D+lt0oHulu2AOD8uUrHxno/Bk=";
  };

  vendorHash = "sha256-WzTen78m/CZypdswwncuVzU3iChBDS26URWGSWQCdfk=";

  meta = with lib; {
    description = "Tool to bypass 40X response codes";
    homepage = "https://github.com/devploit/dontgo403";
    changelog = "https://github.com/devploit/dontgo403/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
