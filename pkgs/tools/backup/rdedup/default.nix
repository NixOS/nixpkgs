{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libsodium
, llvmPackages, clang_39, lzma
, Security }:

rustPlatform.buildRustPackage rec {
  name = "rdedup-${version}";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "dpc";
    repo = "rdedup";
    rev = "rdedup-v${version}";
    sha256 = "0y34a3mpghdmcb2rx4z62q0s351bfmy1287d75mm07ryfgglgsd7";
  };

  cargoSha256 = "0p19qcz2ph6axfccjwc6z72hrlb48l7sf1n0hc1gfq8hj2s3k2s1";

  patches = [
    ./v3.1.1-fix-Cargo.lock.patch
  ];

  nativeBuildInputs = [ pkgconfig llvmPackages.libclang clang_39 ];
  buildInputs = [ openssl libsodium lzma ]
    ++ (stdenv.lib.optional stdenv.isDarwin Security);

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Data deduplication with compression and public key encryption";
    homepage = https://github.com/dpc/rdedup;
    license = licenses.mpl20;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
