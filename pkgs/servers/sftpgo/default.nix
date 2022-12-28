{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "sftpgo";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "drakkan";
    repo = "sftpgo";
    rev = "v${version}";
    sha256 = "sha256-A4+YmChUPn+6P0rBuzYcABXyjXRZWY5KS1YcFZHCrYo=";
  };

  vendorHash = "sha256-kwluXCkbclrfRsrdqSxb5+TCBpVPZmDmrbpzR+yuQdQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/drakkan/sftpgo/v2/internal/version.commit=${src.rev}"
    "-X github.com/drakkan/sftpgo/v2/internal/version.date=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  subPackages = [ "." ];

  postInstall = ''
    $out/bin/sftpgo gen man
    installManPage man/*.1

    installShellCompletion --cmd sftpgo \
      --bash <($out/bin/sftpgo gen completion bash) \
      --zsh <($out/bin/sftpgo gen completion zsh) \
      --fish <($out/bin/sftpgo gen completion fish)
  '';

  meta = {
    homepage = "https://github.com/drakkan/sftpgo";
    description = "Fully featured and highly configurable SFTP server";
    longDescription = ''
      Fully featured and highly configurable SFTP server
      with optional HTTP/S, FTP/S and WebDAV support.
      Several storage backends are supported:
      local filesystem, encrypted local filesystem, S3 (compatible) Object Storage,
      Google Cloud Storage, Azure Blob Storage, SFTP.
    '';
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ thenonameguy ];
  };
}
