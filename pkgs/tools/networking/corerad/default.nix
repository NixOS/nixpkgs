{ lib, buildGo118Module, fetchFromGitHub, nixosTests }:

buildGo118Module rec {
  pname = "corerad";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "sha256-2XPWexpr3xGwnvjT08BVq6uf1haPuZGwKswiy/1Z8vE=";
  };

  vendorSha256 = "sha256-+9KjgbKuAJexdGEKu9hIsHfHsVbKeB5ZtSgFzM2/bOI=";

  doCheck = false;

  # Since the tarball pulled from GitHub doesn't contain git tag information,
  # we fetch the expected tag's timestamp from a file in the root of the
  # repository.
  preBuild = ''
    buildFlagsArray=(
      -ldflags="
        -X github.com/mdlayher/corerad/internal/build.linkTimestamp=$(<.gittagtime)
        -X github.com/mdlayher/corerad/internal/build.linkVersion=v${version}
      "
    )
  '';

  passthru.tests = {
    inherit (nixosTests) corerad;
  };

  meta = with lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "Extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
