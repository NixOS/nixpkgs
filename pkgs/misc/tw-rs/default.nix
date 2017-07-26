{ stdenv, fetchFromGitHub, rustPlatform, perl, zlib, openssl }:

rustPlatform.buildRustPackage rec {
  name = "tw-rs-${version}";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "tw-rs";
    rev = "${version}";
    sha256 = "1s1gk2wcs3792gdzrngksczz3gma5kv02ni2jqrhib8l6z8mg9ia";
    };
  buildInputs = [ perl zlib openssl ];

  depsSha256 = "1lg1jh6f9w28i94vaj62r859g6raalxmxabvw7av6sqr0hr56p05";

  meta = with stdenv.lib; {
    description = "Twitter command-line interface written in rust";
    homepage = https://github.com/vmchale/tw-rs;
    license = licenses.bsd3;
    maintainers = with maintainers; [ vmchale ];
    platforms = platforms.all;
  };
}
