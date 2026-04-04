{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "aws";
  version = "0-unstable-2023-08-03";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-aws";
    rev = "e53a1de3f826916cb83f6ebd34a7356af8f754d1";
    hash = "sha256-l17v/aJ4PkjYM8kJDA0zUo87UTsfFqq+Prei/Qq0DRA=";
  };

  meta = {
    description = "Completions and integrations with the AWS CLI";
    homepage = "https://github.com/oh-my-fish/plugin-aws";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
  };
}
