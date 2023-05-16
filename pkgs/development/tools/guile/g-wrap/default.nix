{ fetchurl, lib, stdenv, guile, guile-lib, libffi, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "g-wrap";
  version = "1.9.15";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0ak0bha37dfpj9kmyw1r8fj8nva639aw5xr66wr5gd3l1rqf5xhg";
  };

  nativeBuildInputs = [ pkg-config ];

  # Note: Glib support is optional, but it's quite useful (e.g., it's used by
  # Guile-GNOME).
  buildInputs = [ guile glib guile-lib ];

  propagatedBuildInputs = [ libffi ];

<<<<<<< HEAD
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = true;

  meta = with lib; {
    description = "A wrapper generator for Guile";
    longDescription = ''
      G-Wrap is a tool (and Guile library) for generating function wrappers for
      inter-language calls.  It currently only supports generating Guile
      wrappers for C functions.
    '';
    homepage = "https://www.nongnu.org/g-wrap/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
