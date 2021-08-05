{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "pgaskin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mxe43U0kxkSdAzs+lSJ0x/VspbJPam59DpTpFEJVMl4=";
  };

  vendorSha256 = "sha256-bLQH7ZY2hE8fBTcW7DNoUQxe4N3m9Mv3JjjKO4cG7DY=";

  # remove when built with >= go 1.17
  tags = [ "zip117" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  excludedPackages = [ "kobotest" ];

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
