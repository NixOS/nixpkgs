{ stdenv, fetchurl, fetchpatch, autoconf, automake, libiconv }:

stdenv.mkDerivation rec {
  name = "unrtf-${version}";
  version = "0.21.9";

  src = fetchurl {
    url = "https://www.gnu.org/software/unrtf/${name}.tar.gz";
    sha256 = "1pcdzf2h1prn393dkvg93v80vh38q0v817xnbwrlwxbdz4k7i8r2";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2016-10091-0001-convert.c-Use-safe-buffer-size-and-snprintf.patch";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=849705;filename=0001-convert.c-Use-safe-buffer-size-and-snprintf.patch;msg=20";
      sha256 = "0s0fjvm3zdm9967sijlipfrwjs0h23n2n8fa6f40xxp8y5qq5a0b";
    })
  ];

  nativeBuildInputs = [ autoconf automake ];

  buildInputs = [ libiconv ];

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
