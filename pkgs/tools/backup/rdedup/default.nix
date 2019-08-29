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

  cargoSha256 = "19j1xscchnckqq1nddx9nr9wxxv124ab40l4mdalqbkli4zd748j";

  patches = [
    ./v3.1.1-fix-Cargo.lock.patch
  ];

  nativeBuildInputs = [ pkgconfig clang_39 ];
  buildInputs = [ openssl libsodium lzma llvmPackages.libclang ]
    ++ (stdenv.lib.optional stdenv.isDarwin Security);

  meta = with stdenv.lib; {
    description = "Data deduplication with compression and public key encryption";
    homepage = https://github.com/dpc/rdedup;
    license = licenses.mpl20;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
