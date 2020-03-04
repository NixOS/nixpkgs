{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "xsv";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "xsv";
    rev = version;
    sha256 = "17v1nw36mrarrd5yv4xd3mpc1d7lvhd5786mqkzyyraf78pjg045";
  };

  cargoSha256 = "1q59nvklh5r2mrsz656z6js3j2l6rqyhfz6l0yq28df5kyahk91b";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A fast CSV toolkit written in Rust";
    homepage = https://github.com/BurntSushi/xsv;
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.jgertm ];
    platforms = platforms.all;
  };
}
