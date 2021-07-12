{ fetchFromGitHub, perl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "sec";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "simple-evcorr";
    repo = "sec";
    rev = version;
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
    license = lib.licenses.gpl2;
    description = "Simple Event Correlator";
    maintainers = [ lib.maintainers.tv ];
    platforms = lib.platforms.all;
  };
}
