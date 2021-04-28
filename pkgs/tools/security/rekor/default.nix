{ lib, buildGoModule, fetchFromGitHub }:

let
  generic = { pname, subPackages, description, postInstall }:
    buildGoModule rec {
      inherit pname;
      version = "0.1.1";

      src = fetchFromGitHub {
        owner = "sigstore";
        repo = "rekor";
        rev = "v${version}";
        sha256 = "1hvkfvc747g5r4h8vb1d8ikqxmlyxsycnlh78agmmjpxlasspmbk";
      };

      vendorSha256 = "0vdir9ia3hv27rkm6jnvhsfc3mxw36xfvwqnfd34rgzmzcfxlrbv";

      inherit subPackages postInstall;

      meta = with lib; {
        inherit description;
        homepage = "https://github.com/sigstore/rekor";
        changelog = "https://github.com/sigstore/rekor/releases/tag/v${version}";
        license = licenses.asl20;
        maintainers = with maintainers; [ lesuisse ];
      };
    };
in {
  rekor-cli = generic {
    pname = "rekor-cli";
    subPackages = [ "cmd/cli" ];
    # Will not be needed with the next version, the package as been renamed upstream
    postInstall = ''
      if [ -f "$out/bin/cli" ]; then
        mv "$out/bin/cli" "$out/bin/rekor-client"
      fi
    '';
    description = "CLI client for Sigstore, the Signature Transparency Log";
  };
  rekor-server = generic {
    pname = "rekor-server";
    subPackages = [ "cmd/server" ];
    # Will not be needed with the next version, the package as been renamed upstream
    postInstall = ''
      if [ -f "$out/bin/server" ]; then
        mv "$out/bin/server" "$out/bin/rekor-server"
      fi
    '';
    description = "Sigstore server, the Signature Transparency Log";
  };
}
