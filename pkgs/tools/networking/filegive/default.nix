{ stdenv, fetchurl, fetchgit, go }:

let

  # Code with BSD license
  srcNatPMP = fetchgit {
    url = https://github.com/jackpal/go-nat-pmp;
    rev = "e04deda90d56";
    sha256 = "1swwfyzaj3l40yh9np3x4fcracgs79nwryc85sxbdakx8wwxs2xb";
  };

in
stdenv.mkDerivation rec {
  name = "filegive-0.7.4";

  src = fetchurl {
    url = "http://viric.name/soft/filegive/${name}.tar.gz";
    sha256 = "1z3vyqfdp271qa5ah0i6jmn9gh3gb296wcm33sd2zfjqapyh12hy";
  };

  buildInputs = [ go ];

  buildPhase = ''
    ${stdenv.lib.optionalString (stdenv.hostPlatform.system == "armv5tel-linux") "export GOARM=5"}

    mkdir $TMPDIR/go
    export GOPATH=$TMPDIR/go

    GONATPMP=$GOPATH/src/code.google.com/p/go-nat-pmp
    mkdir -p $GONATPMP
    cp -R ${srcNatPMP}/* $GONATPMP/
    go build -o filegive
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp filegive $out/bin
  '';

  meta = {
    homepage = http://viric.name/cgi-bin/filegive;
    description = "Easy p2p file sending program";
    license = stdenv.lib.licenses.agpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
