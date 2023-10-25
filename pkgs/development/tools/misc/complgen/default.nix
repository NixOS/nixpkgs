{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "complgen";
  version = "unstable-2023-07-20";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "18ad7e5def8e9b9701a79511a23a2091baad8a9e";
    hash = "sha256-1nNxcYi7HrA2vcggiLC5UPTX3dmM5xgjubnX7WtCq/A=";
  };

  cargoHash = "sha256-rR9wj34QUmIn5HE0k2nOa7HHO5DI+w6BbCgJ4Aelt44=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
