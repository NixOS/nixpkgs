{ lib, stdenv, fetchFromGitHub, autoreconfHook, libewf, afflib, openssl, zlib }:

stdenv.mkDerivation rec {
  version = "4.10.1";
  pname = "sleuthkit";

  src = fetchFromGitHub {
    owner = "sleuthkit";
    repo = "sleuthkit";
    rev = "${pname}-${version}";
    sha256 = "142kkpkpawpqyc88pr6xdvlagw6djaah1schyjxq9qdq9cnqx0dw";
  };

  postPatch = ''
    substituteInPlace tsk/img/ewf.cpp --replace libewf_handle_read_random libewf_handle_read_buffer_at_offset
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libewf afflib openssl zlib ];

  # Hack to fix the RPATH.
  preFixup = "rm -rf */.libs";

  meta = {
    description = "A forensic/data recovery tool";
    homepage = "https://www.sleuthkit.org/";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.ipl10;
    inherit version;
  };
}
