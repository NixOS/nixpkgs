{ stdenv, fetchFromGitHub, autoreconfHook, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "Blackbird";
  version = "2016-07-04";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = "${pname}";
    owner = "shimmerproject";
    rev = "ab4a30ee5110c59241b739e7c54956c3244e5b2a";
    sha256 = "1qy32n21bqq3zwn9di01fbiqv67cqr9n7jmbpcmn9v8yb5p572w3";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gtk-engine-murrine ];

  meta = {
    description = "Dark Desktop Suite for Gtk, Xfce and Metacity";
    homepage = http://github.com/shimmerproject/Blackbird;
    license = with stdenv.lib.licenses; [ gpl2Plus cc-by-nc-sa-30 ];
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
