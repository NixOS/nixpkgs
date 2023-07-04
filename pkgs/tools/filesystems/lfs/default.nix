{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rSnj38U4Rt5Wh+3A610tTeT2Q1BVGvpMa7rpDf4YzTI=";
  };

  cargoHash = "sha256-1I56+ealRdOjFqrD3FmyrNsTJZB+CUUicJXDdOHDGW4=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
