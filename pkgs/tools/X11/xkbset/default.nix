{ stdenv, fetchurl, perl, libX11 }:

stdenv.mkDerivation rec {
  name = "xkbset-0.5";

  src = fetchurl {
    url = "http://faculty.missouri.edu/~stephen/software/xkbset/${name}.tar.gz";
    sha256 = "01c2579495b39e00d870f50225c441888dc88021e9ee3b693a842dd72554d172";
  };

  buildInputs = [ perl libX11 ];

  postPatch = ''
    sed "s:^X11PREFIX=.*:X11PREFIX=$out:" -i Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
  '';

  postInstall = ''
    rm -f $out/bin/xkbset-gui
  '';

  meta = with stdenv.lib; {
    homepage = "http://faculty.missouri.edu/~stephen/software/#xkbset";
    description = "Program to help manage many of XKB features of X window";
    maintainers = with maintainers; [ drets ];
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
