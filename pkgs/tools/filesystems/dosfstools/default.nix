{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dosfstools-${version}";
  version = "3.0.28";

  src = fetchFromGitHub {
    owner = "dosfstools";
    repo = "dosfstools";
    rev = "v${version}";
    sha256 = "0lqirpxcn8ml0anq8aqmaljfsji9h6mdzz0jrs0yqqfhgg90bkg2";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    description = "Utilities for creating and checking FAT and VFAT file systems";
    repositories.git = git://daniel-baumann.ch/git/software/dosfstools.git;
    homepage = http://www.daniel-baumann.ch/software/dosfstools/;
    platforms = stdenv.lib.platforms.linux;
  };
}
