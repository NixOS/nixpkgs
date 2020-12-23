{ stdenv, fetchgit, rustPlatform
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "lotide";
  version = "0.8.0";

  src = fetchgit {
    url = "https://git.sr.ht/~vpzom/lotide";
    rev = "v${version}";
    sha256 = "0qhrr4zfvrizjc0chixfyf71rh0ifxrnzl6hklhbgh6xchknvrgn";
  };

  cargoSha256 = "10jpzcv83l1xsrpz9n2hqaszw40x6kkp39gm71bi2njnbcn1023q";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # requires database to be present.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A federated forum / link aggregator using ActivityPub";
    homepage = "https://sr.ht/~vpzom/lotide/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = with platforms; linux;
  };
}

