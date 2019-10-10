{ stdenv, lib, darwin
, rustPlatform, fetchFromGitHub
, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "v0.4.0";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    sha256 = "07n8h2shjjwgsxww91hcgjgigsz6s81xv6i6xv1hc6lxzmsgkhdr";
  };

  cargoSha256 = "04gyjfhw5s0ig928hfa7h586jgi73xzjbsbjbhz8aim71wd7d60p";

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) pkgconfig;
  buildInputs = lib.optional (!stdenv.isDarwin) openssl;
  propagatedBuildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = https://github.com/killercup/cargo-edit;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli jb55 ];
    platforms = platforms.all;
  };
}
