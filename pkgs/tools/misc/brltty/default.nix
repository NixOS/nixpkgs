{ lib, stdenv, fetchurl, pkg-config, python3, bluez
, alsaSupport ? stdenv.isLinux, alsaLib ? null
, systemdSupport ? stdenv.isLinux, systemd ? null }:

assert alsaSupport -> alsaLib != null;
assert systemdSupport -> systemd != null;

stdenv.mkDerivation rec {
  name = "brltty-6.1";

  src = fetchurl {
    url = "http://brltty.com/archive/${name}.tar.gz";
    sha256 = "0nk54chr7z2w579vyiak9xk2avhnvrx7x2l5sk8nyw2zplchkx9q";
  };

  nativeBuildInputs = [ pkg-config python3.pkgs.cython ];
  buildInputs = [ bluez ]
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional systemdSupport systemd;

  meta = {
    description = "Access software for a blind person using a braille display";
    longDescription = ''
      BRLTTY is a background process (daemon) which provides access to the Linux/Unix
      console (when in text mode) for a blind person using a refreshable braille display.
      It drives the braille display, and provides complete screen review functionality.
      Some speech capability has also been incorporated.
    '';
    homepage = "http://www.brltty.com/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.bramd ];
    platforms = lib.platforms.all;
  };

  makeFlags = [ "PYTHON_PREFIX=$(out)" ];

  preConfigurePhases = [ "preConfigure" ];

  preConfigure = ''
    substituteInPlace configure --replace /sbin/ldconfig ldconfig
  '';
}
