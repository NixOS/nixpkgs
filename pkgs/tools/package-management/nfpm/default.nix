{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, buildPackages
}:

buildGoModule rec {
  pname = "nfpm";
  version = "2.27.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-77E8TXTzU37/V1VmfwUjt/4MiFOrNG+sOHch/brb8bY=";
  };

  vendorHash = "sha256-+Ph0QpDnucf6brWFP05x+s5fCHijaXA7rO1hbesU1Sk=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let emulator = stdenv.hostPlatform.emulator buildPackages;
    in ''
      ${emulator} $out/bin/nfpm man > nfpm.1
      installManPage ./nfpm.1
      installShellCompletion --cmd nfpm \
        --bash <(${emulator} $out/bin/nfpm completion bash) \
        --fish <(${emulator} $out/bin/nfpm completion fish) \
        --zsh  <(${emulator} $out/bin/nfpm completion zsh)
    '';

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = with maintainers; [ marsam techknowlogick caarlos0 ];
    license = with licenses; [ mit ];
  };
}
