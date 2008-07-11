{ fetchurl, stdenv, flex }:

stdenv.mkDerivation rec {
  name = "splint-3.1.2";

  src = fetchurl {
    url = "http://www.splint.org/downloads/${name}.src.tgz";
    sha256 = "02pv8kscsrkrzip9r08pfs9xs98q74c52mlxzbii6cv6vx1vd3f7";
  };

  patches = [ ./tmpdir.patch ];

  buildInputs = [ flex ];

  doCheck = true;

  meta = {
    homepage = http://splint.org/;
    description = "Splint, an annotation-assisted lightweight static analyzer for C";

    longDescription = ''
      Splint is a tool for statically checking C programs for security
      vulnerabilities and coding mistakes.  With minimal effort, Splint
      can be used as a better lint.  If additional effort is invested
      adding annotations to programs, Splint can perform stronger
      checking than can be done by any standard lint.
    '';

    license = "GPLv2+";
  };
}