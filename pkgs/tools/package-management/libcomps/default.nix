{ lib
, check
, cmake
, doxygen
, expat
, fetchFromGitHub
, libxml2
, python
, sphinx
, stdenv
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libcomps";
  version = "0.1.20";

  outputs = [ "out" "dev" "py" ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "libcomps";
    rev = version;
    hash = "sha256-IX4du1+G7lwWrGnllydnBDap2aqK5pzos1Mdyu4MzOU=";
  };

  patches = [
    ./fix-python-install-dir.patch
  ];

  postPatch = ''
    substituteInPlace libcomps/src/python/src/CMakeLists.txt \
      --replace "@PYTHON_INSTALL_DIR@" "$out/${python.sitePackages}"
  '';

  nativeBuildInputs = [
    check
    cmake
    doxygen
    python
    sphinx
  ];

  buildInputs = [
    expat
    libxml2
    zlib
  ];

  dontUseCmakeBuildDir = true;
  cmakeDir = "libcomps";

  postFixup = ''
    ls $out/lib
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  meta = with lib; {
    description = "Comps XML file manipulation library";
    homepage = "https://github.com/rpm-software-management/libcomps";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ katexochen ];
    platforms = platforms.unix;
  };
}
