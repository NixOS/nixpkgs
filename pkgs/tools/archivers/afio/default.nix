{ lib, stdenv, fetchFromGitHub } :

stdenv.mkDerivation rec {
  version = "2.5.2";
  pname = "afio";

  src = fetchFromGitHub {
    owner = "kholtman";
    repo = "afio";
    rev = "v${version}";
    sha256 = "1vbxl66r5rp5a1qssjrkfsjqjjgld1cq57c871gd0m4qiq9rmcfy";
  };

  /*
   * A patch to simplify the installation and for removing the
   * hard coded dependency on GCC.
   */
  patches = [ ./0001-makefile-fix-installation.patch ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = {
    homepage = "https://github.com/kholtman/afio";
    description = "Fault tolerant cpio archiver targeting backups";
    platforms = lib.platforms.all;
    /*
     * Licensing is complicated due to the age of the code base, but
     * generally free. See the file ``afio_license_issues_v5.txt`` for
     * a comprehensive discussion.
     */
    license = lib.licenses.free;
    mainProgram = "afio";
  };
}
