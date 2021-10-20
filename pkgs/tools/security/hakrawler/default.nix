{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "hakrawler";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "hakluke";
    repo = "hakrawler";
    rev = version;
    sha256 = "sha256-g0hJGRPLgnWAeB25iIw/JRANrYowfRtAniDD/yAQWYk=";
  };

  vendorSha256 = "sha256-VmMNUNThRP1jEAjZeJC4q1IvnQEDqoOM+7a0AnABQnU=";

  meta = with lib; {
    description = "Web crawler for the discovery of endpoints and assets";
    homepage = "https://github.com/hakluke/hakrawler";
    longDescription =  ''
      Simple, fast web crawler designed for easy, quick discovery of endpoints
      and assets within a web application.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
