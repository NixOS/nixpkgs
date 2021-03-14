{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libiconv }:

stdenv.mkDerivation rec {
  pname = "dosfstools";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "dosfstools";
    repo = "dosfstools";
    rev = "v${version}";
    sha256 = "1a2zn1655d5f1m6jp9vpn3bp8yfxhcmxx3mx23ai9hmxiydiykr1";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ]
    ++ lib.optional stdenv.isDarwin libiconv;

  configureFlags = [ "--enable-compat-symlinks" ];

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    homepage = "https://github.com/dosfstools/dosfstools";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3;
  };
}
