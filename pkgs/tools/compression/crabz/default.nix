{ lib
, rustPlatform
, fetchFromGitHub
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "crabz";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qKyrAao4b+D9KhK0euNcn2/YyXGeUjgCfdVtDxy6cuQ=";
  };

  cargoHash = "sha256-S3/JDheTBwYS3uEAwwK+bAtzp0LP8FHHxyOnIQkKqlA=";

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
