{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Aop0mNxdea4/Z49HCusKDyGheXzZQhqboz0pv5ElGa0=";
  };

  vendorSha256 = "sha256-sAcDyGNOSm+BnsYyrR2x1vkGo6ZEykhkF7L9lzPrD+o=";

  meta = with lib; {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
