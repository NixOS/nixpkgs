{ stdenv, fetchurl,
  boost, clasp, cmake, gringo, re2c
}:

let
  version = "1.9.0";
in

stdenv.mkDerivation rec {
  name = "aspcud-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/potassco/aspcud/${version}/aspcud-${version}-source.tar.gz";
    sha256 = "029035vcdk527ssf126i8ipi5zs73gqpbrg019pvm9r24rf0m373";
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
    platforms = platforms.linux;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}
