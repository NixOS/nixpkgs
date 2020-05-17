{ stdenv, fetchurl, xorg }:

stdenv.mkDerivation rec {
  pname = "gmemusage";
  version = "0.2";

  src = fetchurl {
    url = "http://ftp.vim.org/ibiblio/system/status/gmemusage-${version}.tar.gz";
    sha256 = "1iv80kr469gqa64837mkrsdfy0ppmrpw1dgbfvgbgigkm948y30x";
  };

  buildInputs = with xorg; [
    libX11
  ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace "-o bin -g bin" ""
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
  '';

  patches = [
    ./debian.patch
  ];

  meta = with stdenv.lib; {
    description = "Graphically display memory used by running processes";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
