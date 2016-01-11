{ stdenv, fetchFromGitHub, autoreconfHook }:

let version = "3.0.11"; in
stdenv.mkDerivation {
  name = "xdelta-${version}";
  
  src = fetchFromGitHub {
    sha256 = "1c7xym7xr26phyf4wb9hh2w88ybzbzh2w3h1kyqq3da0ndidmf2r";
    rev = "v${version}";
    repo = "xdelta-devel";
    owner = "jmacd";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    cd xdelta3
  '';

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
