{ stdenv, fetchgit }:

# Shows the machine check exceptions logged by the kernel.
# E.g. a log is generated when intel processors cpu-throttle.

# The releases of this package are no longer on kernel.org
# hence we fetch them from github. Apparently, these
# are also more recent.

let

  rev = "7fa99818367a6d17014b36d6f918ad848cbe7ce2";
  version = "1.0pre-${stdenv.lib.strings.substring 0 7 rev}"; 
  sha256 = "15eea3acd76190c7922c71028b31963221a2eefd8afa713879e191a26bc22ae7";

in stdenv.mkDerivation {

  name = "mcelog-${version}";

  src = fetchgit {
    url = "https://github.com/andikleen/mcelog";
    inherit sha256;
    inherit rev;
  };

  makeFlags = "prefix=$(out) etcprefix=$(out) DOCDIR=$(out)/share/doc";

  preInstall = ''
    mkdir -p $out/share/doc
  '';

  meta = {
    description = "Tool to display logged machine check exceptions";
    homepage = http://mcelog.org/;
    license = stdenv.lib.licenses.gpl2;
  };
}
