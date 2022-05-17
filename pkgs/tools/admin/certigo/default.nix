{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "certigo";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "square";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XGR6xIXdFLnJTFd+mJneRb/WkLmi0Jscta9Bj3paM1M=";
  };

  vendorSha256 = "sha256-qS/tIi6umSuQcl43SI4LyL0k5eWfRWs7kVybRPGKcbs=";

  # Go running under Hydra Darwin x86_64 picks CHAPOLY instead of AES-GCM as
  # the default TLS ciphersuite, and breaks the arguably flakey `TestConnect`
  # test.
  doCheck = !(stdenv.isDarwin && stdenv.isx86_64);

  meta = with lib; {
    description = "A utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
