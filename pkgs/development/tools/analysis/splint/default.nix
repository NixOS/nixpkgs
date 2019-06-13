{ fetchurl, stdenv, flex }:

stdenv.mkDerivation rec {
  name = "splint-3.1.2";

  src = fetchurl {
    url = "http://www.splint.org/downloads/${name}.src.tgz";
    sha256 = "02pv8kscsrkrzip9r08pfs9xs98q74c52mlxzbii6cv6vx1vd3f7";
  };

  patches = [ ./tmpdir.patch ] ++ stdenv.lib.optional stdenv.isDarwin ./darwin.patch;

  buildInputs = [ flex ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.splint.org/;
    description = "Annotation-assisted lightweight static analyzer for C";

    longDescription = ''
      Splint is a tool for statically checking C programs for security
      vulnerabilities and coding mistakes.  With minimal effort, Splint
      can be used as a better lint.  If additional effort is invested
      adding annotations to programs, Splint can perform stronger
      checking than can be done by any standard lint.
    '';

    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
