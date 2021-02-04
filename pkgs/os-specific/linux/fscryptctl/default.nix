{ lib, stdenv, fetchFromGitHub }:

# Don't use this for anything important yet!

stdenv.mkDerivation rec {
  pname = "fscryptctl";
  version = "0.1.0";

  goPackagePath = "github.com/google/fscrypt";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscryptctl";
    rev = "v${version}";
    sha256 = "1853hlpklisbqnkb7a921dsf0vp2nr2im26zpmrs592cnpsvk3hb";
  };

  makeFlags = [ "DESTDIR=$(out)/bin" ];

  meta = with lib; {
    description = "Small C tool for Linux filesystem encryption";
    longDescription = ''
      fscryptctl is a low-level tool written in C that handles raw keys and
      manages policies for Linux filesystem encryption, specifically the
      "fscrypt" kernel interface which is supported by the ext4, f2fs, and
      UBIFS filesystems.
      fscryptctl is mainly intended for embedded systems which can't use the
      full-featured fscrypt tool, or for testing or experimenting with the
      kernel interface to Linux filesystem encryption. fscryptctl does not
      handle key generation, key stretching, key wrapping, or PAM integration.
      Most users should use the fscrypt tool instead, which supports these
      features and generally is much easier to use.
      As fscryptctl is intended for advanced users, you should read the kernel
      documentation for filesystem encryption before using fscryptctl.
    '';
    inherit (src.meta) homepage;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
