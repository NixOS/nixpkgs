{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "xc";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ACOi9MdsHZ7Td8pcYGj6Oy7uE/g/Mx7B+Uqw6K9hIrE=";
  };

  vendorHash = "sha256-YETiKG8/+DFd9paqy58YYzCKZ47cWlhnUWHjrw5CrDI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    local INSTALL="$out/bin/xc"
    installShellCompletion --cmd xc \
      --bash <(echo "complete -C $INSTALL xc") \
      --zsh <(echo "complete -o nospace -C $INSTALL xc")
  '';

  meta = with lib; {
    homepage = "https://xcfile.dev/";
    description = "Markdown defined task runner";
    license = licenses.mit;
    maintainers = with maintainers; [ joerdav ];
  };
}
