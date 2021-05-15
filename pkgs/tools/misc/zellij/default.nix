{ lib, fetchFromGitHub, rustPlatform, stdenv, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aqiJPYoG1Yi5bK0gos+2OoycrrqdIY2GjpQGE1PK1bw=";
  };

  cargoSha256 = "sha256-j9eZ2kHK9Mxxcv/yuriJ55xs2waCaWT5XQOSlA+WZXE=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  postInstall = ''
    installShellCompletion --cmd $pname \
      --bash <($out/bin/zellij setup --generate-completion bash) \
      --fish <($out/bin/zellij setup --generate-completion fish) \
      --zsh <($out/bin/zellij setup --generate-completion zsh)
  '';

  meta = with lib; {
    description = "A terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealansh _0x4A6F ];
  };
}
