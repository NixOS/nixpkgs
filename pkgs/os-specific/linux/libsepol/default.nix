{ stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  pname = "libsepol";
  version = "2.7";
  se_release = "20170804";
  se_url = "https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchurl {
    url = "${se_url}/${se_release}/libsepol-${version}.tar.gz";
    sha256 = "1rzr90d3f1g5wy1b8sh6fgnqb9migys2zgpjmpakn6lhxkc3p7fn";
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

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  passthru = { inherit se_release se_url; };

  meta = with stdenv.lib; {
    description = "SELinux binary policy manipulation library";
    homepage = http://userspace.selinuxproject.org;
    platforms = platforms.linux;
    maintainers = [ maintainers.phreedom ];
    license = stdenv.lib.licenses.gpl2;
  };
}
