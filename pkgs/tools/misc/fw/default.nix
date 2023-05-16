{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
<<<<<<< HEAD
, zlib
, stdenv
, darwin
=======
, stdenv
, Security
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "fw";
<<<<<<< HEAD
  version = "2.17.1";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fw";
    rev = "v${version}";
    hash = "sha256-8Jq7VjTKwq8n9lrwTzazkkrq8/mNacFTwz/M+eAwBWM=";
  };

  cargoHash = "sha256-tIrACx4KRjfxLyxTiP32PpdN8NegaHBIkINsPGgygVQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A workspace productivity booster";
    homepage = "https://github.com/brocode/fw";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
