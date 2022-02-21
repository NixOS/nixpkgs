{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UGeIY/wms4QxIzt+ctclUStuNNV6Hm3A4Wu+LfaKgbw=";
  };

  cargoSha256 = "sha256-c4rT6Y7XsmNrCtASkt6KWGTwGXwTM2berfdmSC61Z7s=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
