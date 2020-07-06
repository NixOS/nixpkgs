{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "yq-go";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "mikefarah";
    rev = version;
    repo = "yq";
    sha256 = "1rdpjxnq6cs6gwpp4bijp38b657yzjqcdzf98lhhpbpskjz8k8pp";
  };

  vendorSha256 = "1bjy3qr26zndr3dhh9gd33rhm5gy779525qgzjw4a4mla0p2q6kl";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/yq shell-completion --variation $shell > yq.$shell
      installShellCompletion yq.$shell
    done
  '';

  meta = with lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    license = [ licenses.mit ];
    maintainers = [ maintainers.lewo ];
  };
}
