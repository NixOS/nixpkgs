{ stdenv, fetchFromGitHub, autoreconfHook, libewf, afflib, openssl, zlib }:

stdenv.mkDerivation rec {
  version = "4.6.2";
  name = "sleuthkit-${version}";

  src = fetchFromGitHub {
    owner = "sleuthkit";
    repo = "sleuthkit";
    rev = name;
    sha256 = "1ykl6ijf15mjfvmkk9b4gj18kspdairn7ms4wsi2v9kb25776skx";
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
