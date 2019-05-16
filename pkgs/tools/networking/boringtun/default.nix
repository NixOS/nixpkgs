{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "boringtun";
  # "boringtun" is still undergoing review for security concerns.
  # The GitHub page does not show any release yet,
  # use 20190407 as version number to indicate that it is an unstable version.
  version = "20190407";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "b040eb4fd1591b1d5ceb07c6cbb0856553f50adc";
    sha256 = "04i53dvxld2a0xzr0gfl895rcwfvisj1rfs7rl0444gml8s8xyb3";
  };

  cargoSha256 = "0mqgd5r3rdzaw3vkmz0rswn3cwq9b4im6g4rrq7wr7pgrzq96xwm";

  # To prevent configuration phase error that is caused by
  # lacking a new line in file ".cargo/config",
  # we append a new line to the end of file.
  preConfigure = "echo '' >> .cargo/config";

  # Testing this project requires sudo, Docker and network access, etc.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Userspace WireGuard® implementation in Rust";
    homepage = https://github.com/cloudflare/boringtun;
    license = licenses.bsd3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
