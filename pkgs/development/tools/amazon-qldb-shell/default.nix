{ stdenv
, lib
, clang
, cmake
, fetchFromGitHub
, llvmPackages
, rustPlatform
, testers
, Security
}:

let
  pname = "amazon-qldb-shell";
  version = "2.0.1";
  package = rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "awslabs";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-aXScqJ1LijMSAy9YkS5QyXtTqxd19lLt3BbyVXlbw8o=";
    };

    nativeBuildInputs = [ clang cmake ];
    buildInputs = [ llvmPackages.libclang ]
      ++ lib.optional stdenv.isDarwin Security;

    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "amazon-qldb-driver-0.1.0" = "sha256-az0rANBcryHHnpGWvo15TGGW4KMUULZHaj5msIHts14=";
      };
    };

    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

    passthru.tests.version = testers.testVersion { inherit package; };

    meta = with lib; {
      description = "An interface to send PartiQL statements to Amazon Quantum Ledger Database (QLDB)";
      homepage = "https://github.com/awslabs/amazon-qldb-shell";
      license = licenses.asl20;
      maintainers = [ maintainers.terlar ];
      mainProgram = "qldb";
    };
  };
in
package
