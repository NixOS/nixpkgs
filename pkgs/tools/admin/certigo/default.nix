{ lib, stdenv, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "certigo";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "square";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XGR6xIXdFLnJTFd+mJneRb/WkLmi0Jscta9Bj3paM1M=";
  };

  patches = [
    (fetchpatch {
      name = "backport_TestConnect-Apple-Fixes.patch";
      url = "https://github.com/square/certigo/commit/5332ac7ca20bdea63657cc8319e8b8fda4326938.patch";
      sha256 = "sha256-mSNuiui2dxkXnCrXJ/asIzC8F1mtPecOVOIu6mE5jq4=";
    })

    (fetchpatch {
      name = "backport_TestConnect-Expected-CipherSuite-Fixes.patch";
      url = "https://github.com/square/certigo/commit/7ef0417bde4aafc69cbb72f0dd6d3577a56054a1.patch";
      sha256 = "sha256-TUQ8B23HKheaPUjj4NkvjmZBAAhDNTyo2c8jf4qukds=";
    })
  ];

  vendorSha256 = "sha256-qS/tIi6umSuQcl43SI4LyL0k5eWfRWs7kVybRPGKcbs=";

  meta = with lib; {
    description = "A utility to examine and validate certificates in a variety of formats";
    homepage = "https://github.com/square/certigo";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
