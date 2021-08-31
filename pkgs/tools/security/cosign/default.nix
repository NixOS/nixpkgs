{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, PCSC, pivKeySupport ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FG6LAaz6n2l77Wr7SYmwzL10G5gyHPCPG05hQlsOQBI=";
  };

  buildInputs =
    lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config ];

  vendorSha256 = "sha256-OKQVgF/pg4cigMkckX/dclieHCoD39ltR+DegaUfSDk=";

  excludedPackages = "\\(copasetic\\)";

  tags = lib.optionals pivKeySupport [ "pivkey" ];

  ldflags = [ "-s" "-w" "-X github.com/sigstore/cosign/cmd/cosign/cli.gitVersion=v${version}" ];

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
