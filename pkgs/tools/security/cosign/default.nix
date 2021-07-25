{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, PCSC, pivKeySupport ? true }:

buildGoModule rec {
  pname = "cosign";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h0lhbcrynaiwpgpkcn10yrn90j03g00w9hr2lvsj3cwmdbz0rcz";
  };

  buildInputs =
    lib.optional (stdenv.isLinux && pivKeySupport) (lib.getDev pcsclite)
    ++ lib.optionals (stdenv.isDarwin && pivKeySupport) [ PCSC ];

  nativeBuildInputs = [ pkg-config ];

  vendorSha256 = "0f3al6ds0kqyv2fapgdg9i38rfx6h169pmj6az0sfnkh2psq73ia";

  subPackages = [ "cmd/cosign" ];

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
