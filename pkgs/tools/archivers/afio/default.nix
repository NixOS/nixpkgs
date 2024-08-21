{ lib, stdenv, fetchFromGitHub, fetchpatch } :

stdenv.mkDerivation rec {
  version = "2.5.2";
  pname = "afio";

  src = fetchFromGitHub {
    owner = "kholtman";
    repo = "afio";
    rev = "v${version}";
    sha256 = "1vbxl66r5rp5a1qssjrkfsjqjjgld1cq57c871gd0m4qiq9rmcfy";
  };

  patches = [
    /*
     * A patch to simplify the installation and for removing the
     * hard coded dependency on GCC.
     */
    ./0001-makefile-fix-installation.patch

    # fix darwin build (include headers)
    (fetchpatch {
      url = "https://github.com/kholtman/afio/pull/18/commits/a726614f99913ced08f6ae74091c56969d5db210.patch";
      name = "darwin-headers.patch";
      hash = "sha256-pK8mN29fC2mL4B69Fv82dWFIQMGwquyl825OBDTxzpo=";
    })
  ];

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
