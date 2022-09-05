{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "certgraph";
  version = "20220513";

  src = fetchFromGitHub {
    owner = "lanrat";
    repo = pname;
    rev = version;
    sha256 = "sha256-7tvPiJHZE9X7I79DFNF1ZAQiaAkrtrXiD2fY7AkbWMk=";
  };

  vendorSha256 = "sha256-ErTn7pUCtz6ip2kL8FCe+3Rhs876xtqto+z5nZqQ6cI=";

  meta = with lib; {
    description = "Intelligence tool to crawl the graph of certificate alternate names";
    homepage = "https://github.com/lanrat/certgraph";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
