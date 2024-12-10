{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PvMa2hQYDu42ZzwBZrMQZy48RxUzHMvlLYEzPN3sh1w=";
  };

  cargoHash = "sha256-P7pzyfv+0ckzVjC95a+YW6Ni3sLnqgjoZ4JlnfKO17M=";

  meta = with lib; {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      mgttlinger
    ];
  };
}
