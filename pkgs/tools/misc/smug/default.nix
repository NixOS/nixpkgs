{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "smug";
  version = "0.2.7";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "ivaaaan";
    repo = "smug";
    rev = "3399f02a6e01324f5bb881f6b049c9e8d94733ee";
    sha256 = "178125835dhnaq9k42yv4pfxpyhgb5179wrxkimb59fy0nk8jzx8";
  };

  vendorSha256 = "1rba5rpvlr8dyhj145b5i57pm4skfpj3vm7vydkn79k6ak6x985x";

  meta = with lib; {
    homepage = "https://github.com/ivaaaan/smug";
    description = "Smug - tmux session manager";
    license = licenses.mit;
    maintainers = with maintainers; [ juboba ];
  };
}
