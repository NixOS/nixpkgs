{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "amber";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "083gpssnhjxp1gr5rn27k9j4pm42wqz76llrn5yh91rwcwvlg1l8";
  };

  cargoSha256 = "199wfc98vq6vgrz8xqqh8lz4j3ig7w66mrk1am9x0viyhj92fvx0";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A code search-and-replace tool";
    homepage = "https://github.com/dalance/amber";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
  };
}
