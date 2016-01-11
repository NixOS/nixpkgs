{ stdenv, fetchFromGitHub, autoreconfHook
, lzmaSupport ? true, xz ? null
}:

assert lzmaSupport -> xz != null;

let
  version = "3.1.0";
  mkWith = flag: name: if flag
    then "--with-${name}"
    else "--without-${name}";
in stdenv.mkDerivation {
  name = "xdelta-${version}";

  src = fetchFromGitHub {
    sha256 = "09mmsalc7dwlvgrda56s2k927rpl3a5dzfa88aslkqcjnr790wjy";
    rev = "v${version}";
    repo = "xdelta-devel";
    owner = "jmacd";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = []
    ++ stdenv.lib.optionals lzmaSupport [ xz ];

  postPatch = ''
    cd xdelta3

    substituteInPlace Makefile.am --replace \
      "common_CFLAGS =" \
      "common_CFLAGS = -DXD3_USE_LARGESIZET=1"
  '';

  configureFlags = [
    (mkWith lzmaSupport "liblzma")
  ];

  enableParallelBuilding = true;

  doCheck = true;
  checkPhase = ''
    mkdir $PWD/tmp
    for i in testing/file.h xdelta3-test.h; do
      substituteInPlace $i --replace /tmp $PWD/tmp
    done
    ./xdelta3regtest
  '';

  installPhase = ''
    install -D -m755 xdelta3 $out/bin/xdelta3
    install -D -m644 xdelta3.1 $out/share/man/man1/xdelta3.1
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Binary differential compression in VCDIFF (RFC 3284) format";
    homepage = http://xdelta.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
