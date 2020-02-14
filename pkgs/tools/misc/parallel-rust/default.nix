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

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0ssawp06fidsppvfzk0balf4fink2vym9688r7k7x7pb2z7cvyqc";

  patches = [ ./fix_cargo_lock_version.patch ];

  meta = with stdenv.lib; {
    description = "A command-line CPU load balancer written in Rust";
    homepage = https://github.com/mmstick/parallel;
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
