{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "eva";
  version = "0.3.0-2";

  src = fetchCrate {
    inherit pname;
    version = "0.3.0";
    sha256 = "sha256-oeNv4rKZAl/gQ8b8Yr7fgQeeszJjzMcf9q1KzYpVS1Y=";
  };

  cargoSha256 = "sha256-WBniKff9arVgNFBY2pwB0QgEBvzCL0Dls+6N49V86to=";

  meta = with lib; {
    description = "A calculator REPL, similar to bc";
    homepage = "https://github.com/NerdyPepper/eva";
    license = licenses.mit;
    maintainers = with maintainers; [ nrdxp ma27 figsoda ];
  };
}
