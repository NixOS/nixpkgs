{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PHkHIIMEaUZRWe+rkco6B4qqp8aIxl5nmARMUJDRtjY=";
  };

  cargoSha256 = "sha256-DIIIs2YPkls8EVZYFgB/Zala11CzT6fxmGy/u81giWo=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
