{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "maddy";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "v${version}";
    sha256 = "1mi607hl4c9y9xxv5lywh9fvpybprlrgqa7617km9rssbgk4x1v7";
  };

  vendorSha256 = "16laf864789yiakvqs6dy3sgnnp2hcdbyzif492wcijqlir2swv7";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/foxcpp/maddy.Version=${version}" ];

  subPackages = [ "cmd/maddy" "cmd/maddyctl" ];

  meta = with lib; {
    description = "Composable all-in-one mail server";
    homepage = "https://foxcpp.dev/maddy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lxea ];
  };
}
