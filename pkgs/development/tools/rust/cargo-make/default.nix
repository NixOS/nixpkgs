{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = pname;
    rev = version;
    sha256 = "14y9rc0j0vhc4fkymfv0ggajq1k6nkg2p3pqykqaqdzp8iq6fvrx";
  };

  cargoSha256 = "1gpcsc9bcvgxjiybzs2n26naqg2dlma7d82vcaqy89hqbj44n68n";
  cargoPatches = [ ./0001-cargo-lock.patch ];

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make/jobs/526470852
  #   https://travis-ci.org/sagiegurari/cargo-make/jobs/526470853
  #   https://travis-ci.org/sagiegurari/cargo-make/jobs/526470854
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Rust task runner and build tool";
    homepage = https://github.com/sagiegurari/cargo-make;
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.all;
  };
}
