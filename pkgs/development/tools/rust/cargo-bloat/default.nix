{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bloat";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "05dk2y223fjaw49sj0pia9ddccs1j0x4fdyz0bnss38dgf1njygx";
  };

  cargoSha256 = "0bpy8888zbqy9b8hkbfsdxqcs88dn2r7p3qnhfn7a6ri4bw7ihhw";

  meta = with stdenv.lib; {
    description = "A tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xrelkd ];
  };
}

