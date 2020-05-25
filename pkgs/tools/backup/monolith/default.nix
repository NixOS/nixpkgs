{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    sha256 = "08xbpn6kdfiyvz5pwx9hkzbgb40z6dicmiry7frclw0aibal9avi";
  };

  cargoSha256 = "10zwyg54f05m6ldpnchqzxjkb6rlpcl80crdnk8s6wkf18qny4i3";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  checkPhase = "cargo test -- --skip tests::cli";

  meta = with stdenv.lib; {
    description = "Bundle any web page into a single HTML file";
    homepage = "https://github.com/Y2Z/monolith";
    license = licenses.unlicense;
    maintainers = with maintainers; [ filalex77 ];
  };
}
