{ stdenv, lib, fetchFromGitHub, glib, readline
, bison, flex, pkgconfig, autoreconfHook, libxslt, makeWrapper
, txt2man, which
# withUi currently doesn't work. It compiles but fails to run.
, withUi ? false, gtk2, gnome2
}:

let
  uiDeps = [ gtk2 ] ++ (with gnome2; [ GConf libglade libgnomeui gnome-doc-utils ]);

in
stdenv.mkDerivation rec {
  pname = "mdbtools";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "cyberemissary";
    repo = "mdbtools";
    rev = version;
    sha256 = "12rhf6rgnws6br5dn1l2j7i77q9p4l6ryga10jpax01vvzhr26qc";
  };

  configureFlags = [ "--disable-scrollkeeper" ];

  nativeBuildInputs = [
    pkgconfig bison flex autoreconfHook txt2man which
  ] ++ lib.optional withUi libxslt;

  buildInputs = [ glib readline ] ++ lib.optionals withUi uiDeps;

  enableParallelBuilding = true;

  meta = with lib; {
    description = ".mdb (MS Access) format tools";
    license = with licenses; [ gpl2 lgpl2 ];
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    inherit (src.meta) homepage;
  };
}
