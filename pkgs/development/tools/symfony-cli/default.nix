{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.4.1";
  vendorSha256 = "sha256-MlsgII1QybyW+B7DGbSyn7VQ36n29yOC0pZnaemEHO8=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-92Pth+IrILWkcP4mm3IcSN4+zs7TNg4CPGT2liop7/I=";
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
