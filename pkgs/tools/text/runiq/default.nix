{ fetchCrate, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "runiq";
  version = "1.2.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0xhd1z8mykxg9kiq8nw5agy1jxfk414czq62xm1s13ssig3h7jqj";
  };

  cargoSha256 = "1g4yfz5xq9lqwh0ggyn8kn8bnzrqfmh7kx455md5ranrqqh0x5db";

  meta = with lib; {
    description = "An efficient way to filter duplicate lines from input, à la uniq";
    homepage = "https://github.com/whitfin/runiq";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
