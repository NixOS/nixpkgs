{ lib, stdenv
, fetchurl
, makeWrapper
, curl
, file
, gtk3
, intltool
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "klavaro";
  version = "3.11";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${pname}-${version}.tar.bz2";
    sha256 = "1rkxaqb62w4mv86fcnmr32lq6y0h4hh92wmsy5ddb9a8jnzx6r7w";
  };

  nativeBuildInputs = [ intltool makeWrapper pkg-config ];
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

  meta = with lib; {
    description = "Free touch typing tutor program";
    homepage = "http://klavaro.sourceforge.net/";
    changelog = "https://sourceforge.net/p/klavaro/code/HEAD/tree/trunk/ChangeLog";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mimame davidak ];
  };
}
