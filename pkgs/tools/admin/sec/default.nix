{ fetchFromGitHub, perl, stdenv }:

stdenv.mkDerivation rec {
  name = "sec-${meta.version}";

  src = fetchFromGitHub {
    owner = "simple-evcorr";
    repo = "sec";
    rev = meta.version;
    sha256 = "0ryic5ilj1i5l41440i0ss6j3yv796fz3gr0qij5pqyd1z21md83";
  };

  buildInputs = [ perl ];

  dontBuild = false;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp sec $out/bin
    cp sec.man $out/share/man/man1/sec.1
  '';

  meta = {
    homepage = "https://simple-evcorr.github.io";
    license = stdenv.lib.licenses.gpl2;
    description = "Simple Event Correlator";
    maintainers = [ stdenv.lib.maintainers.tv ];
    platforms = stdenv.lib.platforms.all;
    version = "2.8.3";
  };
}
