{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hostess";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "cbednarski";
    repo = pname;
    rev = "v${version}";
    sha256 = "1izszf60nsa6pyxx3kd8qdrz3h47ylm17r9hzh9wk37f61pmm42j";
  };

  subPackages = [ "." ];

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with lib; {
    description = "An idempotent command-line utility for managing your /etc/hosts* file.";
    license = licenses.mit;
    maintainers = with maintainers; [ edlimerkaj ];
  };
}
