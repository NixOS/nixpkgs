{ lib, stdenv, rustPlatform, fetchFromGitHub, llvmPackages, Security }:
rustPlatform.buildRustPackage rec {
  pname = "bin-paste";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "w4";
    repo = "bin";
    rev = "v${version}";
    sha256 = "1g67k9m4aflhf2sb2xggh896xgp9vh7n2z0w5kxql0p3xa0shsi9";
  };

  cargoSha256 = "1v2ks2vdr5knn6kri0d03rvzx1mkv5qhv7xphsxpwfyykhbc0j7h";

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Paste bin";
    homepage = "https://github.com/w4/bin";
    license = licenses.wtfpl;
    maintainers = [ maintainers.w4 ];
  };
}
