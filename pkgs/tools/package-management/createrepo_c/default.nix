{ stdenv, fetchFromGitHub, cmake, pkgconfig, bzip2, expat, glib, curl, libxml2, python3, rpm, openssl, sqlite, file, xz, pcre, bash-completion }:

stdenv.mkDerivation rec {
  name = "createrepo_c-${version}";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner  = "rpm-software-management";
    repo   = "createrepo_c";
    rev    = version;
    sha256 = "0cmysc7gdd2czagl4drfh9gin6aa2847vgi30a3p0cfqvczf9cm6";
  };

  patches = [
    ./fix-bash-completion-path.patch
    ./fix-python-install-path.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '@BASHCOMP_DIR@' "$out/share/bash-completion/completions"
    substituteInPlace src/python/CMakeLists.txt \
      --replace "@PYTHON_INSTALL_DIR@" "$out/${python3.sitePackages}"
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ bzip2 expat glib curl libxml2 python3 rpm openssl sqlite file xz pcre bash-completion ];

  meta = with stdenv.lib; {
    description = "C implementation of createrepo";
    homepage    = "http://rpm-software-management.github.io/createrepo_c/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}

