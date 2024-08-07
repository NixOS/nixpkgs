{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  docbook-xsl-nons,
  libnsl,
  libtirpc,
  libxcrypt,
  libxml2,
  libxslt,
  pkg-config,
  rpcbind,
  systemdLibs,
}:

stdenv.mkDerivation rec {
  pname = "ypbind-mt";
  version = "2.7.2";

  nativeBuildInputs = [
    autoreconfHook
    docbook-xsl-nons
    pkg-config
    libxml2
    libxslt
  ];

  buildInputs = [
    libnsl
    libtirpc
    libxcrypt
    rpcbind
    systemdLibs
  ];

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "ypbind-mt";
    rev = "v${version}";
    hash = "sha256-P8LH1vBTrNdgUQhzeixxBZR4atXyRVF+DuUbR6UeBJY=";
  };

  outputs = [ "out" ];

  configurePhase = ''
    runHook preConfigure

    ./configure --prefix=/
    sed -i -e 's/^#yp/yp/g' man/Makefile
    sed -i -E 's/^#(\s+\$)/\1/g' man/Makefile
    sed -i '/xmllint/d' man/Makefile

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    DESTDIR="$out" make install

    runHook postInstall
  '';

  meta = with lib; {
    description = "Multithreaded daemon maintaining the NIS binding informations.";
    homepage = "https://github.com/thkukuk/ypbind-mt";
    changelog = "https://github.com/thkukuk/ypbind-mt/blob/master/NEWS";
    license = licenses.gpl2;
    platforms = platforms.linux;
    mainProgram = "ypbind";
    maintainers = with maintainers; [ barroff ];
  };
}
