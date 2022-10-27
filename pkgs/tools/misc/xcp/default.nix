{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fzwlDYjNCWAnMrRSGvR+OwL+TEs4eRsjqF7uPjui3T0=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoSha256 = "sha256-c3jUG/ysTzV/67HmGgFSM0KWKlQKo6iqOCQT4E9QA9k=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
  };
}
