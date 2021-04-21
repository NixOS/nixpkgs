{ stdenv, lib, buildGoModule, fetchFromGitHub, pcsclite, pkg-config, PCSC }:

buildGoModule rec {
  pname = "cosign";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gfzard6bh78xxgjk14c9zmdplppkcjqxhvfazcbv8qppjl2pbbd";
  };

  buildInputs =
    lib.optional stdenv.isLinux (lib.getDev pcsclite)
    ++ lib.optionals stdenv.isDarwin [ PCSC ];

  nativeBuildInputs = [ pkg-config ];

  vendorSha256 = "15163v484rv08rn439y38r9spyqn3lf4q4ly8xr18nnf4bs3h6y2";

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
