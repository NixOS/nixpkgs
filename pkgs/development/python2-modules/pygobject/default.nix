{ lib, stdenv, fetchurl, buildPythonPackage, pkg-config, glib, gobject-introspection,
pycairo, cairo, which, ncurses, meson, ninja, isPy3k, gnome }:

buildPythonPackage rec {
  pname = "pygobject";
  version = "3.36.1";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0b9CgC0c7BE7Wtqg579/N0W0RSHcIWNYjSdtXNYdcY8=";
  };

  outputs = [ "out" "dev" ];

  mesonFlags = [
    "-Dpython=python${if isPy3k then "3" else "2" }"
  ];

  nativeBuildInputs = [ pkg-config meson ninja gobject-introspection ];
  buildInputs = [ glib gobject-introspection ]
                 ++ lib.optionals stdenv.isDarwin [ which ncurses ];
  propagatedBuildInputs = [ pycairo cairo ];

  meta = with lib; {
    homepage = "https://pygobject.readthedocs.io/";
    description = "Python bindings for Glib";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
