{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, nix-update-script
}:

buildGoModule rec {
  pname = "supabase-cli";
  version = "1.27.4";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-pF94rGVWhW0KIoSHijkqsoMkzrNd21ncGU+PKqffkZU=";
  };

  vendorSha256 = "sha256-RO9dZP236Kt8SSpZFF7KRksrjgwiEkPxE5DIMUK69Kw=";

  ldflags = [ "-s" "-w" "-X" "github.com/supabase/cli/cmd.version=${version}" ];

  doCheck = false; # tests are trying to connect to localhost

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    rm $out/bin/{codegen,docgen,listdep}
    mv $out/bin/{cli,supabase}

    installShellCompletion --cmd supabase \
      --bash <($out/bin/supabase completion bash) \
      --fish <($out/bin/supabase completion fish) \
      --zsh <($out/bin/supabase completion zsh)
  '';

  passthru.updateScript = nix-update-script {
    attrPath = "supabase-cli";
  };

  meta = with lib; {
    description = "A CLI for interacting with supabase";
    homepage = "https://github.com/supabase/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
    mainProgram = "supabase";
  };
}
