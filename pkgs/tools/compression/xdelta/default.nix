{ stdenv, fetchFromGitHub, autoreconfHook
, lzmaSupport ? true, xz ? null
}:

assert lzmaSupport -> xz != null;

let
  mkWith = flag: name: if flag
    then "--with-${name}"
    else "--without-${name}";
in stdenv.mkDerivation rec {
  pname = "xdelta";
  version = "3.1.0";

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
    description = "Binary differential compression in VCDIFF (RFC 3284) format";
    longDescription = ''
      xdelta is a command line program for delta encoding, which generates two
      file differences. This is similar to diff and patch, but it is targeted
      for binary files and does not generate human readable output.
    '';
    homepage = http://xdelta.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
