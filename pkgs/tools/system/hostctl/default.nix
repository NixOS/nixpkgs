{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "hostctl";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "guumaster";
    repo = pname;
    rev = "v${version}";
    sha256 = "02bjii97l4fy43v2rb93m9b0ad8y6mjvbvp4sz6a5n0w9dm1z1q9";
  };

  vendorSha256 = "1lqk3cda0frqp2vwkqa4b3xkdw814wgkbr7g9r2mwxn85fpdcq5c";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/guumaster/hostctl/cmd/hostctl/actions.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd hostctl \
      --bash <($out/bin/hostctl completion bash) \
      --zsh <($out/bin/hostctl completion zsh)
  '';

  meta = with lib; {
    description = "Your dev tool to manage /etc/hosts like a pro!";
    longDescription = ''
      This tool gives you more control over the use of your hosts file.
      You can have multiple profiles and switch them on/off as you need.
    '';
    homepage = "https://guumaster.github.io/hostctl/";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

