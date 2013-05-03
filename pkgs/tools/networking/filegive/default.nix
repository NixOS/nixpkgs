{ stdenv, fetchurl, fetchgit, go }:

assert stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64 || stdenv.isArm);

let

  # Code with BSD license
  srcNatPMP = fetchgit {
    url = "https://code.google.com/p/go-nat-pmp/";
    rev = "e04deda90d56";
    sha256 = "1swwfyzaj3l40yh9np3x4fcracgs79nwryc85sxbdakx8wwxs2xb";
  };

  version = "0.5.1";

in
stdenv.mkDerivation rec {
  name = "filegive-${version}";

  src = fetchurl {
    url = "http://viric.name/cgi-bin/filegive/tarball/${name}.tar.gz?uuid=v${version}";
    name = "${name}.tar.gz";
    sha256 = "0b8x2g5c9j5v36s62yzdcnj4b76ahiz1brkilm3mv1qkck2y6wwb";
  };

  buildInputs = [ go ];

  buildPhase = ''
    ${stdenv.lib.optionalString (stdenv.system == "armv5tel-linux") "export GOARM=5"}

    mkdir $TMPDIR/go
    export GOPATH=$TMPDIR/go

    GONATPMP=$GOPATH/src/code.google.com/p/go-nat-pmp
    mkdir -p $GONATPMP
    cp -R ${srcNatPMP}/* $GONATPMP/
    go build -o filegive
  '';

  installPhase = ''
    ensureDir $out/bin
    cp filegive $out/bin
  '';

  meta = {
    homepage = http://viric.name/cgi-bin/filegive;
    description = "Easy p2p file sending program";
    license = "BSD";
  };
}
