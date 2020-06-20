{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1ag55n3gfwcp6v8v3hha8bdqxw9r4bmz97p00vyqla9gjzn5ka9w";
  };

  vendorSha256 = "0lann22hjdcrwyab76hinvbbmg3rf7y3knrxlfg0164gl3y5xb5g";

  subPackages = [ "cmd/reviewdog" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
