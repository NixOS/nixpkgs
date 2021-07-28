{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, PCSC, pivKeySupport ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s9mv580habr8pprdz2n5jisxakd10vv1y79fhwfcs29njr7yi7v";
  };

  buildInputs =
    lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config ];

  vendorSha256 = "0njvgykzpiym5w5b4ddnnq597qm90hcng51lf01yf6csir7nyr12";

  excludedPackages = "\\(copasetic\\)";

  preBuild = ''
    buildFlagsArray+=(${lib.optionalString pivKeySupport "-tags=pivkey"})
  '';
  ldflags = [ "-s" "-w" "-X github.com/sigstore/cosign/cmd/cosign/cli.gitVersion=v${version}"];

  meta = with lib; {
    homepage = "https://github.com/sigstore/cosign";
    changelog = "https://github.com/sigstore/cosign/releases/tag/v${version}";
    description = "Container Signing CLI with support for ephemeral keys and Sigstore signing";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse jk ];
  };
}
