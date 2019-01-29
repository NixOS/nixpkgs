{ stdenv, fetchFromGitHub, autoreconfHook, libewf, afflib, openssl, zlib }:

stdenv.mkDerivation rec {
  version = "4.6.5";
  name = "sleuthkit-${version}";

  src = fetchFromGitHub {
    owner = "sleuthkit";
    repo = "sleuthkit";
    rev = name;
    sha256 = "1q1cdixnfv9v4qlzza8xwdsyvq1vdw6gjgkd41yc1d57ldp1qm0c";
  };

  postPatch = ''
    substituteInPlace tsk/img/ewf.c --replace libewf_handle_read_random libewf_handle_read_buffer_at_offset
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libewf afflib openssl zlib ];

  # Hack to fix the RPATH.
  preFixup = "rm -rf */.libs";

  meta = {
    description = "A forensic/data recovery tool";
    homepage = https://www.sleuthkit.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.ipl10;
    inherit version;
  };
}
