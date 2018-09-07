{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "cargo-release-${version}";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "sunng87";
    repo = "cargo-release";
    rev = "${version}";
    sha256 = "1wp7x6nmmhi019iyvyva26k14f4fsxrh424s2pgrr09nqlrfjbz0";
  };

  cargoSha256 = "0qxwkp6w7ir3hs0r587k3jmh69afc7j411bsy6k8hlm8g9clgby5";

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = https://github.com/sunng87/cargo-release;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli ];
    platforms = platforms.all;
  };
}
