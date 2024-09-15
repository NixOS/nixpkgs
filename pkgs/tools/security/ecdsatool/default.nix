{ lib, stdenv, pkgs }:

stdenv.mkDerivation {
  version = "0.0.1";
  pname = "ecdsatool";

  src = pkgs.fetchFromGitHub {
    owner = "kaniini";
    repo = "ecdsatool";
    rev = "7c0b2c51e2e64d1986ab1dc2c57c2d895cc00ed1";
    sha256 = "08z9309znkhrjpwqd4ygvm7cd1ha1qbrnlzw64fr8704jrmx762k";
  };

  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out
  '';

  patches = [
    ./ctype-header-c99-implicit-function-declaration.patch
    ./openssl-header-c99-implicit-function-declaration.patch
  ];

  nativeBuildInputs = with pkgs; [openssl autoconf automake];
  buildInputs = with pkgs; [libuecc];

  meta = with lib; {
    description = "Create and manipulate ECC NISTP256 keypairs";
    mainProgram = "ecdsatool";
    homepage = "https://github.com/kaniini/ecdsatool/";
    license = with licenses; [free];
    platforms = platforms.unix;
  };
}
