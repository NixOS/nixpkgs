{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+BkHE4vl1oYNR5SX2y7Goly7OwGDXRoZex6YL7Xv2QI=";
  };

  cargoSha256 = "sha256-njrjuLHDmcubw8lLPpS9K5la0gRIKq4OrP+MXs1Ro/o=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
