{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h535fnmwm1ix08a3ifasppqcm7z4fiwf6kn32vhqqpn7x9vvl53";
  };

  cargoSha256 = "00j2czhb0ag10hwq7ycdwr2ndb6gz99kg12hlmaq4mkaf8h254nn";

  meta = with lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

