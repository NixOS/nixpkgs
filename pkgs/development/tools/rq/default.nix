{ stdenv, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rq";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "dflemstr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0km9d751jr6c5qy4af6ks7nv3xfn13iqi03wq59a1c73rnf0zinp";
  };

  cargoSha256 = "0071q08f75qrxdkbx1b9phqpbj15r79jbh391y32acifi7hr35hj";

  postPatch = ''
    # Remove #[deny(warnings)] which is equivalent to -Werror in C.
    # Prevents build failures when upgrading rustc, which may give more warnings.
    substituteInPlace src/lib.rs \
      --replace "#![deny(warnings)]" ""
  '';

  meta = with lib; {
    description = "A tool for doing record analysis and transformation";
    homepage = "https://github.com/dflemstr/rq";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ aristid Br1ght0ne ];
  };
}
