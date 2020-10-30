{ stdenv, lib
, rustPlatform, fetchFromGitHub
, libusb1, pkg-config, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flash";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bcpv1r4pdpp22w7za7kdy7jl487x3nlwxiz6sqq3iq6wq3j9zj0";
  };

  cargoSha256 = "1pf117fgw9x9diksqv58cw7i0kzmp25yj73y5ll69sk46b6z4j90";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "A cargo extension for working with microcontrollers";
    homepage = "http://probe.rs/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ fooker ];
  };
}
