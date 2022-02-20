{ lib
, clang
, cmake
, fetchFromGitHub
, llvmPackages
, rustPlatform
, testVersion
}:

let
  pname = "amazon-qldb-shell";
  version = "2.0.0";
  package = rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "awslabs";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-Pnm1HxEjjNKpS3tTymtOXxUF7EEnWM+7WBsqeaG8seA=";
    };

    nativeBuildInputs = [ clang cmake ];
    buildInputs = [ llvmPackages.libclang ];

    cargoSha256 = "sha256-EUqGSKcGnhrdLn8ystaLkkR31RjEvjW6vRzKPMK77e8=";

    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

    passthru.tests.version = testVersion { inherit package; };

    meta = with lib; {
      description = "An interface to send PartiQL statements to Amazon Quantum Ledger Database (QLDB)";
      homepage = "https://github.com/awslabs/amazon-qldb-shell";
      license = licenses.asl20;
      maintainers = [ maintainers.terlar ];
    };
  };
in
package
