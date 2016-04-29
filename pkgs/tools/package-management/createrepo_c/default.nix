{ stdenv, fetchFromGitHub, cmake, pkgconfig, bzip2, expat, glib, curl, libxml2, python, rpm, openssl, sqlite, file, xz, pcre, bashCompletion }:

stdenv.mkDerivation rec {
  rev  = "0.10.0";
  name = "createrepo_c-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "rpm-software-management";
    repo   = "createrepo_c";
    sha256 = "1sqzdkj9vigkvxsjlih1i0gylv53na2yic5if9w1s2sgxhqqz5zv";
  };

  # FIXME: ugh, there has to be a better way to do this...
  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'execute_process(COMMAND ''${PKG_CONFIG_EXECUTABLE} --variable=completionsdir bash-completion OUTPUT_VARIABLE BASHCOMP_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)' \
                "set (BASHCOMP_DIR "$out/share/bash-completion/completions")"

    substituteInPlace src/python/CMakeLists.txt \
      --replace 'EXECUTE_PROCESS(COMMAND ''${PYTHON_EXECUTABLE} -c "from sys import stdout; from distutils import sysconfig; stdout.write(sysconfig.get_python_lib(True))" OUTPUT_VARIABLE PYTHON_INSTALL_DIR)' \
                "set (PYTHON_INSTALL_DIR "$out/${python.sitePackages}")"
  '';

  buildInputs = [ cmake pkgconfig bzip2 expat glib curl libxml2 python rpm openssl sqlite file xz pcre bashCompletion ];
}

