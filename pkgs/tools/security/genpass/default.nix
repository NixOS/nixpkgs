{ lib, stdenv
, fetchgit
, rustPlatform
, CoreFoundation
, libiconv
, Security
}:
rustPlatform.buildRustPackage rec {
  pname = "genpass";
  version = "0.4.9";

  src = fetchgit {
    url = "https://git.sr.ht/~cyplo/genpass";
    rev = "v${version}";
    sha256 = "1dpv2iyd48xd8yw9bmymjjrkhsgmpwvsl5b9zx3lpaaq59ypi9g9";
  };

  cargoSha256 = "0xbiwpl6dw64kn2xwxa7ig5rrf36qhdk2ya4cddyjx2xy4gkzrxl";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation libiconv Security ];

  meta = with lib; {
    description = "A simple yet robust commandline random password generator";
    homepage = "https://sr.ht/~cyplo/genpass/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ cyplo ];
  };
}
