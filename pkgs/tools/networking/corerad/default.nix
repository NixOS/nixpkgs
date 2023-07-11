{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "corerad";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "sha256-cBP4jJhnIx+UwcbuQ3xbpImkLX4jSnsyvwfOEs31On4=";
  };

  vendorSha256 = "sha256-RkwfHjWu40AW+7zLc+sY5p2nyy3YPHk5sjt6foC103k=";

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
    platforms = platforms.linux;
  };
}
