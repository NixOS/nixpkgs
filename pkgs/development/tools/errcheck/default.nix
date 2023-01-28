{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "errcheck";
  version = "unstable-2022-03-26";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "e62617a91f7bd1abab2cbe7f28966188dd85eee0";
    sha256 = "sha256-RoPv6Odh8l9DF1S50pNEomLtI4uTDNjveOXZd4S52c0=";
  };

  vendorSha256 = "sha256-fDugaI9Fh0L27yKSFNXyjYLMMDe6CRgE6kVLiJ3+Kyw=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Checks for unchecked errors in go programs";
    homepage = "https://github.com/kisielk/errcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
