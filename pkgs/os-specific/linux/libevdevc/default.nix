{ lib, stdenv, fetchFromGitHub, coreutils, pkg-config, glib, jsoncpp }:

stdenv.mkDerivation rec {
  pname = "libevdevc";
  version = "2.0.1";
  src = fetchFromGitHub {
    owner = "hugegreenbug";
    repo = "libevdevc";
    rev = "v${version}";
    sha256 = "0ry30krfizh87yckmmv8n082ad91mqhhbbynx1lfidqzb6gdy2dd";
  };

  postPatch = ''
    substituteInPlace common.mk \
      --replace /bin/echo ${coreutils}/bin/echo
    substituteInPlace include/module.mk \
      --replace /usr/include /include
  '';

  makeFlags = [ "DESTDIR=$(out)" "LIBDIR=/lib" ];

  meta = with lib; {
    description = "ChromiumOS libevdev. Renamed to avoid conflicts with the standard libevdev found in Linux distros";
    license = licenses.bsd3;
    platforms = platforms.linux;
    homepage = "https://chromium.googlesource.com/chromiumos/platform/libevdev/";
    maintainers = with maintainers; [ kcalvinalvin ];
  };
}
