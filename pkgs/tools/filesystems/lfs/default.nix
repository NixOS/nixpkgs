{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v1hFH/3iRyUCZzV+QECOpOmKc+izarlOE9EVEDMh6fo=";
  };

  cargoSha256 = "sha256-8daO6fbCOp0+Y1jRH1CgqM+B2/AABwIZ2+3i/qtpIxM=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
