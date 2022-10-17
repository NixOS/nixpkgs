{ lib, stdenv
, fetchurl
, makeWrapper
, curl
, espeak
, file
, gtk3
, gtkdatabox
, intltool
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "klavaro";
  version = "3.13";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${pname}-${version}.tar.bz2";
    sha256 = "0z6c3lqikk50mkz3ipm93l48qj7b98lxyip8y6ndg9y9k0z0n878";
  };

  nativeBuildInputs = [ intltool makeWrapper pkg-config ];
  buildInputs = [ curl gtk3 gtkdatabox ];

  postPatch = ''
    substituteInPlace src/tutor.c --replace '"espeak ' '"${espeak}/bin/espeak '
  '';

  patches = [ ./icons.patch ./trans_lang_get_similar.patch ];

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
