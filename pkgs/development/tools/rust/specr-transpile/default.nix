{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "specr-transpile";
  version = "0.1.21";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-tFiCE6UJ7Jl/KJ7efwcHrX511Rs14ck4a7eY4dpusUc=";
  };

  cargoHash = "sha256-zBo1tLyfNSt04TuYP/SYmqC0ov9HmuXF013EqvrvY20=";

  meta = with lib; {
    description = "Converts Specr lang code to Rust";
    homepage = "https://github.com/RalfJung/minirust-tooling";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
