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

<<<<<<< HEAD
  vendorHash = "sha256-ErTn7pUCtz6ip2kL8FCe+3Rhs876xtqto+z5nZqQ6cI=";
=======
  vendorSha256 = "sha256-ErTn7pUCtz6ip2kL8FCe+3Rhs876xtqto+z5nZqQ6cI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Intelligence tool to crawl the graph of certificate alternate names";
    homepage = "https://github.com/lanrat/certgraph";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
