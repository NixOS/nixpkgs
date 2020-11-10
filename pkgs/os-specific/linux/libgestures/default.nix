{ stdenv, fetchFromGitHub, pkgconfig, glib, jsoncpp }:

stdenv.mkDerivation rec {
  name = "libgestures-${version}";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "hugegreenbug";
    repo = "libgestures";
    rev = "v${version}";
    sha256 = "0dfvads2adzx4k8cqc1rbwrk1jm2wn9wl2jk51m26xxpmh1g0zab";
  };
  patches = [ ./include-fix.patch ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace -Werror -Wno-error \
      --replace '$(DESTDIR)/usr/include' '$(DESTDIR)/include'
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib jsoncpp ];


  makeFlags = [ "DESTDIR=$(out)" "LIBDIR=/lib" ];

  meta = with stdenv.lib; {
    description = "ChromiumOS libgestures modified to compile for Linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    homepage = "https://chromium.googlesource.com/chromiumos/platform/gestures";
    maintainers = with maintainers; [ kcalvinalvin ];
  };
}
