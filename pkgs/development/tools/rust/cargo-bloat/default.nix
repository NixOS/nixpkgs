{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bqzzh8vfqm7dpnb0fv4calnhsg9p3c5j06ycvg621p4zp4fydh2";
  };

  cargoSha256 = "0f7hmwrs99qdvhn4lvs8cqva68w2y04fy3ca1xlhk7ncdmclcc4g";

  meta = with lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

