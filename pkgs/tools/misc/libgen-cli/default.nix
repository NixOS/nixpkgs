{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
buildGoModule rec {
  pname = "libgen-cli";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "ciehanski";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ahqwrlsvgiig73dwlbjgkarf3a0z3xaihj8psd2ci5i0i07nm5v";
  };

  vendorSha256 = "15ch0zfl4a7qvwszsfkfgw5v9492wjk4l4i324iq9b50g70lgyhd";

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