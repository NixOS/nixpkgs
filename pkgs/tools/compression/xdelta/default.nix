{ stdenv, fetchFromGitHub, autoreconfHook }:

let version = "3.0.9"; in
stdenv.mkDerivation rec {
  name = "xdelta-${version}";
  
  src = fetchFromGitHub {
    sha256 = "1pd7dyq44dbggmwkrr8251anqsf2an67zbvrk4vfnc92jkmjp17i";
    rev = "v${version}";
    repo = "xdelta-devel";
    owner = "jmacd";
  };

  buildInputs = [ autoreconfHook ];

  postPatch = ''
    cd xdelta3
  '' + stdenv.lib.optionalString doCheck ''
    mkdir tmp
    substituteInPlace testing/file.h --replace /tmp tmp
    substituteInPlace xdelta3-test.h --replace /tmp $PWD/tmp
  '';

  enableParallelBuilding = true;

  doCheck = true;
  checkPhase = ''
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
    license = with licenses; gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
