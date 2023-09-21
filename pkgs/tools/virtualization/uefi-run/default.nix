{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "uefi-run";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Richard-W";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tR547osqw18dCMHJLqJ8AQBelbv8yCl7rAqslu+vnDQ=";
  };

  cargoHash = "sha256-s1Kbc3JHoYy0UJwNfSunIdQ3xHjlQaut/Cb0JSYyB9g=";

  meta = with lib; {
    description = "Directly run UEFI applications in qemu";
    homepage = "https://github.com/Richard-W/uefi-run";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
