{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, libsodium
, llvmPackages, clang, xz
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rdedup";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "dpc";
    repo = "rdedup";
    rev = "rdedup-v${version}";
    sha256 = "0y34a3mpghdmcb2rx4z62q0s351bfmy1287d75mm07ryfgglgsd7";
  };

  cargoSha256 = "1k0pl9i7zf1ki5ch2zxc1fqsf94bxjlvjrkh0500cycwqcdys296";

  cargoPatches = [
    ./v3.1.1-fix-Cargo.lock.patch
  ];

  nativeBuildInputs = [ pkg-config llvmPackages.libclang clang ];
  buildInputs = [ openssl libsodium xz ]
    ++ (lib.optional stdenv.isDarwin Security);

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib"
  '';

  meta = with lib; {
    description = "Data deduplication with compression and public key encryption";
    homepage = "https://github.com/dpc/rdedup";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dywedir ];
    broken = stdenv.isDarwin;
  };
}
