{ lib, stdenv, fetchurl, autoreconfHook, bison, flex }:

stdenv.mkDerivation rec {
  pname = "filebench";
  version = "1.4.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/filebench/${pname}-${version}.tar.gz";
    sha256 = "13hmx67lsz367sn8lrvz1780mfczlbiz8v80gig9kpkpf009yksc";
  };

  nativeBuildInputs = [ autoreconfHook bison flex ];

  meta = with lib; {
    description = "File system and storage benchmark that can generate both micro and macro workloads";
    homepage = "https://sourceforge.net/projects/filebench/";
    license = licenses.cddl;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
    mainProgram = "filebench";
  };
}
