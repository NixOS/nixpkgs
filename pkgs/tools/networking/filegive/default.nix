{ stdenv, fetchurl, fetchgit, go }:

assert stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64 || stdenv.isArm);

let

  # Code with BSD license
  srcNatPMP = fetchgit {
    url = "https://code.google.com/p/go-nat-pmp/";
    rev = "e04deda90d56";
    sha256 = "1swwfyzaj3l40yh9np3x4fcracgs79nwryc85sxbdakx8wwxs2xb";
  };

  version = "0.7";

in
stdenv.mkDerivation rec {
  name = "filegive-${version}";

  src = fetchurl {
    url = "http://viric.name/cgi-bin/filegive/tarball/${name}.tar.gz";
    sha256 = "17vd09vfvy01bsnhlanwpfgjczigxisccm9bpaswg9r2kih39b92";
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
    license = "AGPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
