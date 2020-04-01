{ stdenv, fetchFromGitHub, php, flex, makeWrapper }:

let
  libphutil = fetchFromGitHub {
    owner = "phacility";
    repo = "libphutil";
    rev = "cc2a3dbf590389400da55563cb6993f321ec6d73";
    sha256 = "1k7sr3racwz845i7r5kdwvgqrz8gldz07pxj3yw77s58rqbix3ad";
  };
  arcanist = fetchFromGitHub {
    owner = "phacility";
    repo = "arcanist";
    rev = "21a1828ea06cf031e93082db8664d73efc88290a";
    sha256 = "05rq9l9z7446ks270viay57r5ibx702b5bnlf4ck529zc4abympx";
  };
in
stdenv.mkDerivation {
  pname = "arcanist";
  version = "20200127";

  src = [ arcanist libphutil ];
  buildInputs = [ php makeWrapper flex ];

  unpackPhase = ''
    cp -aR ${libphutil} libphutil
    cp -aR ${arcanist} arcanist
    chmod +w -R libphutil arcanist
  '';

  postPatch = stdenv.lib.optionalString stdenv.isAarch64 ''
    substituteInPlace libphutil/support/xhpast/Makefile \
      --replace "-minline-all-stringops" ""
  '';

  buildPhase = ''
    (
      cd libphutil/support/xhpast
      make clean all install
    )
  '';
  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp -R libphutil $out/libexec/libphutil
    cp -R arcanist  $out/libexec/arcanist

    ln -s $out/libexec/arcanist/bin/arc $out/bin
    wrapProgram $out/bin/arc \
      --prefix PATH : "${php}/bin"
  '';

  meta = {
    description = "Command line interface to Phabricator";
    homepage    = "http://phabricator.org";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
