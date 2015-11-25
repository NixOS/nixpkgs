{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ioping-${version}";
  version = "0.9";
  src = fetchurl {
    url = "https://github.com/koct9i/ioping/releases/download/v${version}/${name}.tar.gz";
    sha256 = "0pbp7b3304y9yyv2w41l3898h5q8w77hnnnq1vz8qz4qfl4467lm";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Disk I/O latency measuring tool";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    homepage = https://github.com/koct9i/ioping;
  };
}
