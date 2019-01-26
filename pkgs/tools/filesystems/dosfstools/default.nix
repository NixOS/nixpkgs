{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libiconv }:

stdenv.mkDerivation rec {
  name = "dosfstools-${version}";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "dosfstools";
    repo = "dosfstools";
    rev = "v${version}";
    sha256 = "1a2zn1655d5f1m6jp9vpn3bp8yfxhcmxx3mx23ai9hmxiydiykr1";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ]
    ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  configureFlags = [ "--enable-compat-symlinks" ];

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    repositories.git = git://daniel-baumann.ch/git/software/dosfstools.git;
    homepage = https://www.daniel-baumann.ch/software/dosfstools/;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    license = stdenv.lib.licenses.gpl3;
  };
}
