{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ent-go";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "ent";
    rev = "v${version}";
    sha256 = "sha256-TG08GRo1gNxC5iHt/Md5WVWaEQ1m2mUDGqpuxw8Pavg=";
  };

  vendorSha256 = "sha256-n5dS78SSBAEgE4/9jMZZhbOQZ3IGi9n3ErA0ioP9Tsg=";

  subPackages = [ "cmd/ent" ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd ent \
      --bash <($out/bin/ent completion bash) \
      --fish <($out/bin/ent completion fish) \
      --zsh <($out/bin/ent completion zsh)
  '';

  meta = with lib; {
    description = "An entity framework for Go";
    downloadPage = "https://github.com/ent/ent";
    license = licenses.asl20;
    homepage = "https://entgo.io/";
    maintainers = with maintainers; [ superherointj ];
  };
}

