{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "13krr1zjh544swv4frfapvyi7bm8qf121x6qz9jqbw2cm3mid301";
  };

  vendorSha256 = "1y4nyw7rpgipblxqaps2zsd07cin8d0i0g9gvsnc3vifi6g29s8z";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
