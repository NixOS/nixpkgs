{ stdenv, fetchurl,
  boost, clasp, cmake, gringo, re2c
}:

let
  version = "1.9.1";
in

stdenv.mkDerivation rec {
  name = "aspcud-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/potassco/aspcud/${version}/aspcud-${version}-source.tar.gz";
    sha256 = "09sqbshwrqz2fvlkz73mns5i3m70fh8mvwhz8450izy5lsligsg0";
  };

  buildInputs = [ boost clasp cmake gringo re2c ];

  buildPhase = ''
    cmake -DCMAKE_BUILD_TYPE=Release \
      -DGRINGO_LOC=${gringo}/bin/gringo \
      -DCLASP_LOC=${clasp}/bin/clasp \
      -DENCODING_LOC=$out/share/aspcud/specification.lp \
      .

    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/{aspcud,cudf2lp,lemon} $out/bin

    mkdir -p $out/share/aspcud
    cp ../share/aspcud/specification.lp $out/share/aspcud
  '';

  meta = with stdenv.lib; {
    description = "Solver for package problems in CUDF format using ASP";
    homepage = http://potasssco.sourceforge.net/;
    platforms = platforms.all;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}
