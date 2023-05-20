{ lib
, buildGoModule
, fetchgit
}:

buildGoModule rec {
  pname = "mcap-cli";
  version = "0.0.31";

  src = fetchgit {
    url = "https://github.com/foxglove/mcap";
    rev = "releases/mcap-cli/v${version}";
    sha256 = "sha256-SmI2MSKf4j6u+MnO1WH4s8i9H9kpUkjIhhrwk/qht2s=";
    fetchLFS = true;
  };

  sourceRoot = "mcap/go/cli/mcap";

  proxyVendor = true;
  vendorHash = "sha256-3TSwOgTIaBg5U8UdQ74LmsS8gS05Yw02JjfaIN9fKQQ=";

  meta = with lib; {
    description = "MCAP CLI tool to inspect and fix MCAP files";
    homepage = "https://github.com/foxglove/mcap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therishidesai ];
  };
}
