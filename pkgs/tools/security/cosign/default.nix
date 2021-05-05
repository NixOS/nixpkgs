{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, PCSC }:

buildGoModule rec {
  pname = "cosign";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "0glpr2mnfv79f1mnkpk3xvfqmc2fx0brzm6l8ny077v3af5xb3fx";
  };

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optionals stdenv.isDarwin [ PCSC ];

  nativeBuildInputs = [ pkg-config ];

  vendorSha256 = "0r09iwac02zlblfwmwq9jz06agdy5zxlh4i5d67cxliynkzf0a74";

  subPackages = [ "cmd/cosign" ];

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X github.com/sigstore/cosign/cmd/cosign/cli.gitVersion=v${version}")
  '';

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
