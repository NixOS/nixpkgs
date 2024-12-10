{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

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

  vendorHash = null;

  meta = with lib; {
    description = "An idempotent command-line utility for managing your /etc/hosts* file.";
    mainProgram = "hostess";
    license = licenses.mit;
    maintainers = with maintainers; [ edlimerkaj ];
  };
}
