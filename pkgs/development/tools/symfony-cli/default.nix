{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.4.19";
  vendorSha256 = "sha256-P5KEliTqj9kGYffhl014QK6qPY9gLG+bViOz4dtsQwA=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-GAsyI8I+tHFMV/LqwPx2ph+w3zaqKSn9vieVQcuO+y0=";
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
