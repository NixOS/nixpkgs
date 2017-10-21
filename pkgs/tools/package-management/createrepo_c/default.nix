{ stdenv, fetchFromGitHub, cmake, pkgconfig, bzip2, expat, glib, curl, libxml2, python2, rpm, openssl, sqlite, file, xz, pcre, bash-completion }:

stdenv.mkDerivation rec {
  rev  = "0.10.0";
  name = "createrepo_c-${rev}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "rpm-software-management";
    repo   = "createrepo_c";
    sha256 = "1sqzdkj9vigkvxsjlih1i0gylv53na2yic5if9w1s2sgxhqqz5zv";
  };

  patches = [
    ./fix-bash-completion-path.patch
    ./fix-python-install-path.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '@BASHCOMP_DIR@' "$out/share/bash-completion/completions"
    substituteInPlace src/python/CMakeLists.txt \
      --replace "@PYTHON_INSTALL_PATH@" "$out/${python2.sitePackages}"
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ bzip2 expat glib curl libxml2 python2 rpm openssl sqlite file xz pcre bash-completion ];

  meta = with stdenv.lib; {
    description = "C implementation of createrepo";
    homepage    = "http://rpm-software-management.github.io/createrepo_c/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

