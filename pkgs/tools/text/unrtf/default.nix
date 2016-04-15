{ stdenv, fetchurl, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "unrtf-${version}";
  version = "0.21.9";

  src = fetchurl {
    url = "https://www.gnu.org/software/unrtf/${name}.tar.gz";
    sha256 = "1pcdzf2h1prn393dkvg93v80vh38q0v817xnbwrlwxbdz4k7i8r2";
  };

  nativeBuildInputs = [ autoconf automake ];

  preConfigure = "./bootstrap";

  outputs = [ "out" "man" ];

  meta = with stdenv.lib; {
    description = "A converter from Rich Text Format to other formats";
    longDescription = ''
      UnRTF converts documents in Rich Text Format to other
      formats, including HTML, LaTeX, and RTF itself.
    '';
    homepage = https://www.gnu.org/software/unrtf/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ joachifm ];
    platforms = platforms.unix;
  };
}
