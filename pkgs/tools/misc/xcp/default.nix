{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P+KrqimZwbUVNAD5P+coBDSjqNnq18g/wSlhT8tWrkA=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-ULHS2uOFh8y011qs51zQQUkq7drqD5TlQkMLAaJsFx8=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
