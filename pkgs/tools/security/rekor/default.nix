{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "rekor-cli";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "rekor";
    rev = "v${version}";
    sha256 = "1hvkfvc747g5r4h8vb1d8ikqxmlyxsycnlh78agmmjpxlasspmbk";
  };

  vendorSha256 = "0vdir9ia3hv27rkm6jnvhsfc3mxw36xfvwqnfd34rgzmzcfxlrbv";

  subPackages = [ "cmd/cli" ];

  # Will not be needed with the next version as the package as been renamed upstream
  postInstall = ''
    if [ -f "$out/bin/cli" ]; then
      mv "$out/bin/cli" "$out/bin/rekor-client"
    fi
  '';

  meta = with lib; {
    description = "CLI client for Sigstore, the Signature Transparency Log";
    homepage = "https://github.com/sigstore/rekor";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
  };
}
