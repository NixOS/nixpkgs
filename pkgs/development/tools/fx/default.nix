{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "fx";
  version = "34.0.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-gVeeCJOqrEua5quID1n1928oHtP9gfIDe4erVn1y2Eo=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-otORAeD9+J6/10TDusEnFfRRxTb/52Zk7Ttaw46xnsU=/sTS1mJw=";

  postInstall = ''
    installShellCompletion --cmd fx \
      --bash <($out/bin/fx --comp bash) \
      --fish <($out/bin/fx --comp fish) \
      --zsh <($out/bin/fx --comp zsh)
  '';

  meta = with lib; {
    description = "Terminal JSON viewer";
    mainProgram = "fx";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
