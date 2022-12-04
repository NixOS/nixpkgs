{ lib, stdenv, fetchFromGitHub, nix, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.22";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "sha256-/oCMqskEoHhXmJ0HZQwnPrt+LU8hfWbyo9sPy8F0zAk=";
  };

  cargoSha256 = "sha256-ew6UsiXHbH4exwq+VxZiw/lJmiAzbdPtOMXTISKAd1U=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  # Tests rely on unset 'RUST_LOG' value to emit INFO messages.
  # 'RUST_LOG=' nixpkgs default enables warnings only and breaks tests.
  # Can be removed when https://github.com/rust-lang/mdBook/pull/1777
  # is released.
  logLevel = "info";

  passthru = {
    tests = {
      inherit nix;
    };
  };

  meta = with lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang/mdBook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
  };
}
