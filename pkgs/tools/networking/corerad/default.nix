{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "corerad";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "04w77cahnphgd8b09a67dkrgx9jh8mvgjfjydj6drcw67v0d18c0";
  };

  modSha256 = "0vbbpndqwwz1mc59j7liaayxaj53cs8s3javgj3pvhkn4vp65p7c";

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "CoreRAD extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
