{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fw";
  version = "2.16.1";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nhkirjq2q9sxg4k2scy8vxlqa9ikvr5lid0f22vws07vif4kkfs";
  };

  cargoSha256 = "sha256-iD3SBSny0mYpmVEInYaylHn0AbtIqTOwJHdFeq3UBaM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  OPENSSL_NO_VENDOR = 1;
  USER = "nixbld";

  meta = with lib; {
    description = "A workspace productivity booster";
    homepage = "https://github.com/brocode/fw";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
