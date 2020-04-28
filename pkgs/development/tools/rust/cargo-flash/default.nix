{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, rustfmt, libusb1 }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-flash";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = pname;
    rev = "v" + version; 
    sha256 = "01zyxbykzbqfy6w0cmhhq10l1qqf4aqxvh4jngj1lqba5r9d7jsc";
  };

  # Update this regurlarly! It may very well happen that cargo-flash is not
  # updated, but new features are released to probe-rs. In this case generating
  # cargo-lock.patch is sufficient to ensure that our cargo-flash pkg follows
  # probe-rs. To update the cargo-lock.patch follow these steps:
  #
  # $ cd /tmp 
  # $ git clone --branch v0.6.0 https://github.com/probe-rs/cargo-flash.git 
  # $ cd cargo-flash
  # $ cargo-update
  # $ git diff Cargo.lock > cargo-lock.patch

  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "1ynlvs4x01jyycj4acawlvwwg5w88zn4d19ril2c4p3z8igarb2c";

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1.dev ];

  meta = with stdenv.lib; {
    description = "A cargo subcommand to flash ELF binaries onto ARM chips";
    homepage = "https://github.com/probe-rs/" + pname;
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.wucke13 ];
    platforms = platforms.all;
  };
}
