{ lib, buildGoModule, fetchFromGitHub, fetchpatch, testVersion, saw }:

buildGoModule rec {
  pname = "saw";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "TylerBrock";
    repo = "saw";
    rev = "v${version}";
    sha256 = "n1DTUb6ZpopCWZ5ekwYI2LJQLgQwvAt3T4B2NulvxEE=";
  };

  patches = [
    # No release has been done since project switched to go modules.
    (fetchpatch {
      url = "https://github.com/TylerBrock/saw/commit/0bb0a886191c3f74db88652a980bdf0891e38183.patch";
      sha256 = "is6rgVBEGSbQq8ZYaVxLzy1N2g/9j7saVpiJCferu0M=";
    })
  ];

  vendorSha256 = "2GTa5BEls5T1k7qQSpi6VprcTrjBmTKz7Ra5OsAJBFA=";

  passthru.tests.version = testVersion {
    package = saw;
    command = "saw version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Fast, multi-purpose tool for AWS CloudWatch Logs";
    homepage = "https://github.com/TylerBrock/saw";
    license = licenses.mit;
    maintainers = [ maintainers.terlar ];
  };
}
