{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, PCSC }:

buildGoModule rec {
  pname = "cosign";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g60qwdxk6pmkzj0zz9iyc8b0bzh751fj2yyz0vilkgcjq47xjk8";
  };

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optionals stdenv.isDarwin [ PCSC ];

  nativeBuildInputs = [ pkg-config ];

  vendorSha256 = "0agmnl5d00hm854sj1iipng36pf7hcc26iwcmpcr1rsmc7v522z4";

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
