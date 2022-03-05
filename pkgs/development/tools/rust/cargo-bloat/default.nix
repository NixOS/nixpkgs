{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UzMo+IqoP3GpGu7tWlrkEU1YpVLgEL7UwIU1hPmoJNg=";
  };

  cargoSha256 = "sha256-w3+ypGuVRGwC94zj/OaDUUoUbBnepGHvqulY4IVIsfo=";

  meta = with lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

