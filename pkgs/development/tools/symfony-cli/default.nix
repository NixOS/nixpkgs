{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.0.7";
  vendorSha256 = "sha256-aTC84iA3/z/qhZbXPtOeZwDGn6BFCefCVlkUrbEtxUI=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-Z3AIlN/s0uPE0OAlgSxbQPRoWPTHjDq4c8RlQ3SuIk8=";
  };

  # Tests requires network access
  doCheck = false;

  meta = with lib; {
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ drupol ];
  };
}
