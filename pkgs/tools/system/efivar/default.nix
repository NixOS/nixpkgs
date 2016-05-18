{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, popt }:

stdenv.mkDerivation rec {
  name = "efivar-${version}";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    sha256 = "1fdqi053v335pjwj1i3yi9f1kasdzg3agfcp36bxsbhqjp4imlid";
  };

  patches = [
    # fix problem with linux 4.4 headers https://github.com/rhinstaller/efivar/issues/37
    (fetchurl {
      url = https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-libs/efivar/files/0.21-nvme_ioctl.h.patch;
      sha256 = "1rjjpd4s1xdsnhq974j5wnwav8pfvd0jbvhk8a9wc2w029fvj7zp";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ popt ];

  postPatch = ''
     substituteInPlace src/Makefile --replace "-static" ""
  '';

  installFlags = [
    "libdir=$(out)/lib"
    "mandir=$(out)/share/man"
    "includedir=$(out)/include"
    "bindir=$(out)/bin"
  ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Tools and library to manipulate EFI variables";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
