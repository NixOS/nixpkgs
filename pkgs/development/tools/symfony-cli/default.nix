{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.4.13";
  vendorSha256 = "sha256-/HJgMCRfSS3ln/bW7pb6x9ugece8MFHTLHARTNMHNEU=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-yTCq+kx86TGjDZ9Cx4d4ni1Q8yvgXSmJP3YD1owrLN8=";
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
