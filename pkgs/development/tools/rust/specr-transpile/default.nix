{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "specr-transpile";
  version = "0.1.22";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-D3UdQ3L7fSSFWlVSjqjEUqNCQebMHOtZnJqO7sBjm14=";
  };

  cargoHash = "sha256-f0Gwxr7J56Q11Rv26mycCYbCidr5bXUwo4kmnVWMCz4=";

  meta = with lib; {
    description = "Converts Specr lang code to Rust";
    homepage = "https://github.com/RalfJung/minirust-tooling";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
