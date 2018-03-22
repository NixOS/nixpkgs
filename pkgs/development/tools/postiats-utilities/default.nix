{ stdenv, fetchurl, python3, python3Packages }:

stdenv.mkDerivation {
  name = "postiats-utilities-2.0.1";
  src = fetchurl {
    url = "https://github.com/Hibou57/PostiATS-Utilities/archive/v2.0.1.tar.gz";
    sha256 = "12jlzqigmaa9m37x0nq5v3gq8v61m73i5kzdnsm06chf0przpaix";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/Hibou57/PostiATS-Utilities;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.ttuegel ];
  };

  buildInputs = [ python3 python3Packages.wrapPython ];

  phases = "unpackPhase patchPhase installPhase";

  postPatch = ''
    for f in pats-* postiats/*.py; do
      sed -i "$f" -e "1 s,python3,python,"
    done
  '';

  installPhase = ''
    libdir="$out/lib/${python3.libPrefix}/site-packages"
    mkdir -p "$libdir"
    cp -r postiats "$libdir"

    mkdir -p "$out/bin"
    install pats-* "$out/bin"

    wrapPythonPrograms
  '';
}
