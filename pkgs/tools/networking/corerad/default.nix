{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "corerad";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "0ky4zfmxzgxidsizfj2lwm5z3zl666khw9cgsxfgbzn3cjgr33c3";
  };

  vendorSha256 = "0ddni8hl8fv0m9kinwfnhcj3k51fk8h61yksv7ws6agdx0bl1rwh";

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
