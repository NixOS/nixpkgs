{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-V7b8NEKzS4wDIhFJkAve94Tl3tzYtnbG01GzyRj8yfA=";
  };

  vendorSha256 = "sha256-uQRAVbLnzY+E3glMJ3AvmbtmwD2LkuqCh2mUpqZbmaA=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
