{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "corerad";
  version = "0.1.9";

  goPackagePath = "github.com/mdlayher/corerad";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "1m23f318qr6b8c7hxrhihrm09pmdwab988k3bn4ygfm49z5phy4s";
  };

  modSha256 = "0idlpkn6krs77akn3p6gxsbc8zpj1rnjkhhwmb8ns98x82g6bln0";

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "CoreRAD extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
