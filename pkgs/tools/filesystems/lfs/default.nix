{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cf9W0LnlvMm0XZe6lvx8hQejcwyfxBC6VKltAAfRD5I=";
  };

  cargoSha256 = "sha256-skP9VJuRMCyA06YjGbyNIt/DljP3fQQOIQDy6k10zGI=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
