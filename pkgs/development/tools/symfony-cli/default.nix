{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.3.4";
  vendorSha256 = "sha256-i4p9kEe0eT2L4U/DjkWlLVqgGT5ZJaoGyFAoYyxmoyI=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-6k1yMGW/UYCFB1APGlcU8bjNcCD7/IXhG+RJR6ii56I=";
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
