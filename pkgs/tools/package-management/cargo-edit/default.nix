{ stdenv, lib, darwin
, rustPlatform, fetchFromGitHub
, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    sha256 = "087l8qdwfnnklw6zyjwflxh7hyhh4r7wala36cc4lrj7lag2xm9n";
  };

  cargoSha256 = "1ih1p9jdwr1ymq2p6ipz6rybi17f3qn65kn4bqkgzx36afvpnd5l";

  nativeBuildInputs = lib.optional (!stdenv.isDarwin) pkgconfig;
  buildInputs = lib.optional (!stdenv.isDarwin) openssl;
  propagatedBuildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  patches = [
    # https://github.com/killercup/cargo-edit/pull/362
    ./no_upgrade_index_in_tests.patch
  ];

  # The default `/build` will fail the test (seems) due to permission problem.
  preCheck = ''
    export TMPDIR="/tmp"
  '';

  meta = with lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = https://github.com/killercup/cargo-edit;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli jb55 ];
    platforms = platforms.all;
  };
}
