{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, curl, file, gtk3 }:

stdenv.mkDerivation rec {
  pname = "klavaro";
  version = "3.09";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${pname}-${version}.tar.bz2";
    sha256 = "12gml7h45b1w9s318h0d5wxw92h7pgajn2kh57j0ak9saq0yb0wr";
  };

  # Fix for https://sourceforge.net/p/klavaro/bugs/56/
  patches = [ ./patch1 ];

  nativeBuildInputs = [ intltool makeWrapper pkgconfig ];
  buildInputs = [ curl gtk3 ];

  postInstall = ''
    wrapProgram $out/bin/klavaro \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  preConfigure = ''
    substituteInPlace configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with stdenv.lib; {
    description = "Just another free touch typing tutor program";
    homepage = "http://klavaro.sourceforge.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mimame ];
  };
}
