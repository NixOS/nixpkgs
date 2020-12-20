{ stdenv
, fetchFromGitHub
, cmake
, python
, pkgconfig
, libxml2
, glib
, openssl
, zchunk
, curl
, check
, gpgme
}:

stdenv.mkDerivation rec {
  version = "1.12.1";
  pname = "librepo";

  outputs = [ "out" "dev" "py" ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "librepo";
    rev = version;
    sha256 = "0793j35fcv6bbz2pkd5rcsmx37hb1f0y48r4758cbfnl9rbp9y4z";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    python
    libxml2
    glib
    openssl
    curl
    check
    gpgme
  ]
  # zchunk currently has issues compiling in darwin, fine in linux
  ++ stdenv.lib.optional stdenv.isLinux zchunk;

  # librepo/fastestmirror.h includes curl/curl.h, and pkg-config specfile refers to others in here
  propagatedBuildInputs = [
    curl
    gpgme
    libxml2
  ];

  cmakeFlags = [
    "-DPYTHON_DESIRED=${stdenv.lib.substring 0 1 python.pythonVersion}"
  ] ++ stdenv.lib.optional stdenv.isDarwin "-DWITH_ZCHUNK=OFF";

  postFixup = ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  meta = with stdenv.lib; {
    description = "Library providing C and Python (libcURL like) API for downloading linux repository metadata and packages";
    homepage = "https://rpm-software-management.github.io/librepo/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ copumpkin ];
  };
}
