{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "amber";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0k70rk19hwdlhhqm91x12xcb8r09kzpijs0xwhplrwdh86qfxymx";
  };

  cargoSha256 = "0g8n3r6bdsfl1417wnss3ggnv5ywz8mx53hjglshmln40552znh3";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A code search-and-replace tool";
    homepage = https://github.com/dalance/amber;
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
    platforms = platforms.all;
  };
}
