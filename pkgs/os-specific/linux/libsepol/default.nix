{ stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  pname = "libsepol";
  version = "2.9";
  se_release = "20190315";
  se_url = "https://github.com/SELinuxProject/selinux/releases/download";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchurl {
    url = "${se_url}/${se_release}/libsepol-${version}.tar.gz";
    sha256 = "0p8x7w73jn1nysx1d7416wqrhbi0r6isrjxib7jf68fi72q14jx3";
  };

  nativeBuildInputs = [ flex ];

  makeFlags = [
    "PREFIX=$(out)"
    "BINDIR=$(bin)/bin"
    "INCDIR=$(dev)/include/sepol"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN8DIR=$(man)/share/man/man8"
    "SHLIBDIR=$(out)/lib"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  passthru = { inherit se_release se_url; };

  meta = with stdenv.lib; {
    description = "SELinux binary policy manipulation library";
    homepage = http://userspace.selinuxproject.org;
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    license = stdenv.lib.licenses.gpl2;
  };
}
