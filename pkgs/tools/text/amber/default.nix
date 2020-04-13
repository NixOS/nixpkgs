{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "amber";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pqz3spb5lmrj7w8hynmah9nrcfjsb1s0bmrr0cng9a9jx8amwzn";
  };

  cargoSha256 = "1ps70swh96xbfn4hng5krlmwvw2bwrl2liqvx9v9vy6pr86643s6";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A code search-and-replace tool";
    homepage = "https://github.com/dalance/amber";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
    platforms = platforms.all;
  };
}
