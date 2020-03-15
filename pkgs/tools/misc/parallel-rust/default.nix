{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "parallel-rust";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "mmstick";
    repo = "parallel";
    rev = version;
    sha256 = "1bb1m3ckkrxlnw9w24ig70bd1zwyrbaw914q3xz5yv43c0l6pn9c";
  };

  cargoSha256 = "1r5chjhmy6ivhsvgqf75ph1qxa4x7n20f7rb3b6maqpbsc64km9n";

  patches = [ ./fix_cargo_lock_version.patch ];

  meta = with stdenv.lib; {
    description = "A command-line CPU load balancer written in Rust";
    homepage = https://github.com/mmstick/parallel;
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
