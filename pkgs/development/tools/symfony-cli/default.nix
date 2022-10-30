{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.4.17";
  vendorSha256 = "sha256-hIi+WmLxCTFbu8E++CJkp4bOUrK81PkojRk60SljVik=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-cOO8U0/PnH19/oaK9wM/mPplC+VTIkF5+RXdjWJyxqc=";
  };

  postInstall = ''
    mv $out/bin/symfony-cli $out/bin/symfony
  '';

  # Tests requires network access
  doCheck = false;

  meta = with lib; {
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ drupol ];
  };
}
