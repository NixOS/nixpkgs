{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libsodium
, llvmPackages, clang, lzma
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

  cargoSha256 = "1zvg68ilgpnd95b36jvna9h1jr5d72x1a0g6flw2x6sd0msc0mdw";

  patches = [
    ./v3.1.1-fix-Cargo.lock.patch
  ];

  nativeBuildInputs = [ pkgconfig llvmPackages.libclang clang ];
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
