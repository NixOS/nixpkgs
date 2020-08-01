{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
buildGoModule rec {
  pname = "libgen-cli";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "ciehanski";
    repo = pname;
    rev = "v${version}";
    sha256 = "15nzdwhmgpm36dqx7an5rjl5sw2r4p66qn2y3jzl6fc0y7224ns1";
  };

  vendorSha256 = "0smb83mq711b2pby57ijcllccn7y2l10zb4fbf779xibb2g09608";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/libgen-cli completion $shell > libgen-cli.$shell || :
      installShellCompletion libgen-cli.$shell
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/ciehanski/libgen-cli";
    description =
      "A CLI tool used to access the Library Genesis dataset; written in Go";
    longDescription = ''
      libgen-cli is a command line interface application which allows users to
      quickly query the Library Genesis dataset and download any of its
      contents.
    '';
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ zaninime ];
  };
}
