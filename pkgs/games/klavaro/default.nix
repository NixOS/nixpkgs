{ stdenv
, fetchurl
, makeWrapper
, curl
, file
, gtk3
, intltool
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "klavaro";
  version = "3.10";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${pname}-${version}.tar.bz2";
    sha256 = "0jnzdrndiq6m0bwgid977z5ghp4q61clwdlzfpx4fd2ml5x3iq95";
  };

  nativeBuildInputs = [ intltool makeWrapper pkgconfig ];
  buildInputs = [ curl gtk3 ];

  postInstall = ''
    wrapProgram $out/bin/klavaro \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  # Fixes /usr/bin/file: No such file or directory
  preConfigure = ''
    substituteInPlace configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with stdenv.lib; {
    description = "Free touch typing tutor program";
    homepage = "http://klavaro.sourceforge.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mimame davidak ];
  };
}
