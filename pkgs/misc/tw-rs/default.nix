{ stdenv, fetchFromGitHub, rustPlatform, perl, zlib, openssl, curl }:

rustPlatform.buildRustPackage rec {
  name = "tw-rs-${version}";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "tw-rs";
    rev = "${version}";
    sha256 = "1s1gk2wcs3792gdzrngksczz3gma5kv02ni2jqrhib8l6z8mg9ia";
    };

  buildInputs = [ perl zlib openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin curl;

  cargoSha256 = "0c3324b7z77kiwc6whbppfmrli254fr1nyd0vpsxvpc0av3279jg";

  meta = with stdenv.lib; {
    description = "Twitter command-line interface written in rust";
    homepage = https://github.com/vmchale/tw-rs;
    license = licenses.bsd3;
    maintainers = with maintainers; [ vmchale ];
    platforms = platforms.all;
  };
}
