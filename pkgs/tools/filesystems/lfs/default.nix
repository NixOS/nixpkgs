{ lib
, stdenv
, pkgs
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "Aljel9ZlxoX/kubTrcr5WQjaW3YTZL6W5Gl/hVlkuWQ=";
  };

  cargoSha256 = "9LOWKBd2pKLBc+VRi87rz5X6WGqD/UcgvhrUmqy3LTQ=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
