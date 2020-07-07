{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, rustfmt, libusb1 }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flash";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v" + version; 
    sha256 = "1bcpv1r4pdpp22w7za7kdy7jl487x3nlwxiz6sqq3iq6wq3j9zj0";
  };

  cargoSha256 = "1pf117fgw9x9diksqv58cw7i0kzmp25yj73y5ll69sk46b6z4j90";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1.dev ];

  meta = with stdenv.lib; {
    description = "A cargo subcommand to flash ELF binaries onto ARM chips";
    homepage = "https://github.com/probe-rs/cargo-flash";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.wucke13 ];
    platforms = platforms.all;
  };
}
