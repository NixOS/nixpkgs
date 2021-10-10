{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "lfs";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "gez5q1niIhzWJpsEkbVRuQFILo3tTO8aJq7ewZArJ5M=";
  };

  cargoSha256 = "2U1xDG4bTimtmjwZ1z9ErlaOcBNJdRcHlEWVaiGg01M=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/lfs";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
