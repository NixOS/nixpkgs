{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "6.0.1";
  name = "coan-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/coan2/v${version}/${name}.tar.gz";
    sha256 = "1d041j0nd1hc0562lbj269dydjm4rbzagdgzdnmwdxr98544yw44";
  };

  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  postInstall = ''
    mv -v $out/share/man/man1/coan.1.{1,gz}
  '';

  meta = with stdenv.lib; {
    description = "The C preprocessor chainsaw";
    longDescription = ''
      A software engineering tool for analysing preprocessor-based
      configurations of C or C++ source code. Its principal use is to simplify
      a body of source code by eliminating any parts that are redundant with
      respect to a specified configuration. Dead code removal is an
      application of this sort.
    '';
    homepage = http://coan2.sourceforge.net/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
