{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, bzip2, expat, glib, curl, libxml2, python3, rpm
, openssl, sqlite, file, xz, pcre, bash-completion, zstd, zchunk, libmodulemd
}:

stdenv.mkDerivation rec {
  pname = "createrepo_c";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner  = "rpm-software-management";
    repo   = "createrepo_c";
    rev    = version;
    sha256 = "G2xioH9XWntHFmUfTN2s2mdtIqgTTLKr5jZflwpaC8Q=";
  };

  patches = [
    # Use the output directory to install the bash completions.
    ./fix-bash-completion-path.patch
    # Use the output directory to install the python modules.
    ./fix-python-install-path.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '@BASHCOMP_DIR@' "$out/share/bash-completion/completions"
    substituteInPlace src/python/CMakeLists.txt \
      --replace "@PYTHON_INSTALL_DIR@" "$out/${python3.sitePackages}"
  '';

  nativeBuildInputs = [ cmake pkg-config rpm ];

  buildInputs = [ bzip2 expat glib curl libxml2 python3 openssl sqlite file xz pcre bash-completion zstd zchunk libmodulemd ];

  meta = with lib; {
    description = "C implementation of createrepo";
    homepage    = "https://rpm-software-management.github.io/createrepo_c/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ copumpkin ];
  };
}

