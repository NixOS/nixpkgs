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
  version = "3.14";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${pname}-${version}.tar.bz2";
    hash = "sha256-hxh+SdMBxRDmlkCYzbYSEmvwMNKodf15nq3K0+rlbas=";
  };

  nativeBuildInputs = [ intltool makeWrapper pkg-config ];
  buildInputs = [ curl gtk3 gtkdatabox ];

  postPatch = ''
    substituteInPlace src/tutor.c --replace '"espeak ' '"${espeak}/bin/espeak '
  '';

  postInstall = ''
    wrapProgram $out/bin/klavaro \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  # Fixes /usr/bin/file: No such file or directory
  preConfigure = ''
    substituteInPlace configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  # remove forbidden references to $TMPDIR
  preFixup = lib.optionalString stdenv.isLinux ''
    for f in "$out"/bin/*; do
      if isELF "$f"; then
        patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$f"
      fi
    done
  '';

  meta = with lib; {
    description = "Free touch typing tutor program";
    mainProgram = "klavaro";
    homepage = "http://klavaro.sourceforge.net/";
    changelog = "https://sourceforge.net/p/klavaro/code/HEAD/tree/trunk/ChangeLog";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mimame davidak ];
  };
}
