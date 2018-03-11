{ stdenv, fetchFromGitHub, openssl, coreutils, which }:

stdenv.mkDerivation rec {

  name = "${pname}-${version}";
  pname = "bdsync";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "TargetHolding";
    repo = pname;
    rev = "v${version}";
    sha256 = "144hlbk3k29l7sja6piwhd2jsnzzsak13fcjbahd6m8yimxyb2nf";
  };

  postPatch = ''
    patchShebangs ./tests.sh
    patchShebangs ./tests/
  '';

  buildInputs = [ openssl coreutils which ];

  doCheck = true;
  checkPhase = ''
    make test
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp bdsync $out/bin/
    cp bdsync.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "Fast block device synchronizing tool";
    homepage = https://github.com/TargetHolding/bdsync;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };

}
