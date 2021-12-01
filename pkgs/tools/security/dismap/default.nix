{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dismap";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "zhzyker";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d5r6n92ndlr48f4z6lxwrx7bdh5mmibdjcyab4j2h49lf37c1qd";
  };

  vendorSha256 = "00hwhc86rj806arvqfhfarmxs1drcdp91xkr12whqhsi9ddc254d";

  meta = with lib; {
    description = "Asset discovery and identification tools";
    homepage = "https://github.com/zhzyker/dismap";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
