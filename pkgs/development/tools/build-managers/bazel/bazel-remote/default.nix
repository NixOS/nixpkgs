{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.3.9";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z6DCe2rkWnTaxvfhLd+ZGxLw2ldjaSPkPz/zHKzI1fs=";
  };

  vendorSha256 = "sha256-BThOF6Kodmq0PqofiS24GffmTFRangrf6Q1SJ7mDVvY=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    license = licenses.asl20;
    maintainers = lib.teams.bazel.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
