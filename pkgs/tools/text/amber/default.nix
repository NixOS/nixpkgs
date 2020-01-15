{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "amber";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jwrkd6qhxj2mqsfmhk687k15f7gf36gjyxnynj0yh8db2db6mjc";
  };

  cargoSha256 = "0iv8zvglwaihcc89dk9kkhchbj1g3v8wq8jcbrgcbclcsyymmplc";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A code search-and-replace tool";
    homepage = https://github.com/dalance/amber;
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
    platforms = platforms.all;
  };
}
