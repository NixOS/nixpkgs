{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, PCSC, pivKeySupport ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-peR/TPydR4O6kGkRUpOgUCJ7xGRLbl9pYB1lAehjVK4=";
  };

  buildInputs =
    lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config ];

  vendorSha256 = "sha256-DyRMQ43BJOkDtWEqmAzqICyaSyQJ9H4i69VJ4dCGF44=";

  excludedPackages = "\\(copasetic\\|sample\\|webhook\\)";

  tags = lib.optionals pivKeySupport [ "pivkey" ];

  ldflags = [ "-s" "-w" "-X github.com/sigstore/cosign/cmd/cosign/cli.GitVersion=v${version}" ];

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
