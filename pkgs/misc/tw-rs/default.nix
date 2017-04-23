{ stdenv, fetchFromGitHub, rustPlatform, perl, zlib, openssl }:

rustPlatform.buildRustPackage rec {
  name = "tw-rs-${version}";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "tw-rs";
    rev = "${version}";
    sha256 = "1xydb0f1q02pv7vs28gqwsgmn55gh8zic302fnvagm9dgdvaqv96";
  };
  buildInputs = [ perl zlib openssl ];

  depsSha256 = "1cgzh8bb0vvcfyzaw47xwm54w51xm7yw74s5pwrpfngdy3w9b4sp";

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/tw $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Twitter command-line interface written in rust";
    homepage = https://github.com/vmchale/tw-rs;
    license = licenses.bsd3;
    #maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
