{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "maddy";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "v${version}";
    sha256 = "sha256-IhVEb6tjfbWqhQdw1UYxy4I8my2L+eSOCd/BEz0qis0=";
  };

  vendorSha256 = "sha256-FrKWlZ3pQB+oo+rfHA8AgGRAr7YRUcb064bZGTDSKkk=";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/foxcpp/maddy.Version=${version}" ];

  subPackages = [ "cmd/maddy" "cmd/maddyctl" ];

  meta = with lib; {
    description = "Composable all-in-one mail server";
    homepage = "https://foxcpp.dev/maddy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lxea ];
  };
}
