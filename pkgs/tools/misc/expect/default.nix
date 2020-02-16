{ stdenv, fetchurl, tcl, makeWrapper, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "5.45.4";
  pname = "expect";

  src = fetchurl {
    url = "mirror://sourceforge/expect/Expect/${version}/expect${version}.tar.gz";
    sha256 = "0d1cp5hggjl93xwc8h1y6adbnrvpkk0ywkd00inz9ndxn21xm9s9";
  };

  buildInputs = [ tcl ];
  nativeBuildInputs = [ makeWrapper autoreconfHook ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    sed -i "s,/bin/stty,$(type -p stty),g" configure.in
  '';

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tclinclude=${tcl}/include"
    "--exec-prefix=\${out}"
  ];

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i \
        --prefix PATH : "${tcl}/bin" \
        --prefix TCLLIBPATH ' ' $out/lib/* \
        ${stdenv.lib.optionalString stdenv.isDarwin "--prefix DYLD_LIBRARY_PATH : $out/lib/expect${version}"}
    done
  '';

  meta = with stdenv.lib; {
    description = "A tool for automating interactive applications";
    homepage = http://expect.sourceforge.net/;
    license = "Expect";
    platforms = platforms.unix;
  };
}
