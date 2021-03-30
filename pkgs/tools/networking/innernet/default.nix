{ lib, stdenv, rustPlatform, fetchFromGitHub, llvmPackages, linuxHeaders, sqlite, darwin ? null }:

rustPlatform.buildRustPackage rec {
  pname = "innernet";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tonarino";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OomCSA02ypFVzkYMcmkFREWB6x7oxgpt7x2zRANIDMw=";
  };
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  nativeBuildInputs = with llvmPackages; [ llvm clang ];
  buildInputs = [ sqlite ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  cargoSha256 = "sha256-xNw3IMnWKMlOijohurLoaYmSnqY/+doTm9wDIl5AMxc=";

  meta = with lib; {
    description = "A private network system that uses WireGuard under the hood";
    homepage = "https://github.com/tonarino/innernet";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek _0x4A6F ];
  };
}
