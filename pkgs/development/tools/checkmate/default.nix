{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tgiZDTPIAYirPX6nGPEAt6BoYEC8uUJwT6zuHJqPF1w=";
  };

  vendorSha256 = "sha256-eL1fLJwzVpU9NqaAl5R/fbaqI3AnEkl6EuPkMTuY86w=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
