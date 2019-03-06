{ stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  name = "libsepol-${version}";
  version = "2.8";
  se_release = "20180524";
  se_url = "https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchurl {
    url = "${se_url}/${se_release}/libsepol-${version}.tar.gz";
    sha256 = "1mi4kpx7b94wjphv8k2fz5b8rd7mllvq1k4ssjxg1gjjhdm93mis";
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
    maintainers = with maintainers; [ phreedom e-user ];
    license = stdenv.lib.licenses.gpl2;
  };
}
