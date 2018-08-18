{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, libsodium
, llvmPackages, clang_39, lzma }:

rustPlatform.buildRustPackage rec {
  name = "rdedup-${version}";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "dpc";
    repo = "rdedup";
    rev = "e0f26f379a434f76d238c7a5fa6ddd8ae8b32f19";
    sha256 = "1nhf8ap0w99aa1h0l599cx90lcvfvjaj67nw9flq9bmmzpn53kp9";
  };

  cargoSha256 = "1x6wchlcxb1frww6y04gfx4idxv9h0g9qfxrhgb6g5qy3bqhqq3p";

  nativeBuildInputs = [ pkgconfig llvmPackages.libclang clang_39 ];
  buildInputs = [ openssl libsodium lzma ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Data deduplication with compression and public key encryption";
    homepage = https://github.com/dpc/rdedup;
    license = licenses.mpl20;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
