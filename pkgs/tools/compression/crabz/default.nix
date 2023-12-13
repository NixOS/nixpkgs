{ lib
, rustPlatform
, fetchFromGitHub
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "crabz";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-w/e0NFmBsYNEECT+2zHEm/UUpp5LxPYr0BdKikT2o1M=";
  };

  cargoSha256 = "sha256-9VOJeRvyudZSCaUZ1J9gHMEoWXEnEhCZPxvfYGRKzj0=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A cross platform, fast, compression and decompression tool";
    homepage = "https://github.com/sstadick/crabz";
    changelog = "https://github.com/sstadick/crabz/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "crabz";
  };
}
