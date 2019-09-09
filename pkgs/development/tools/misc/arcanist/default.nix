{ stdenv, fetchFromGitHub, php, flex, makeWrapper }:

let
  libphutil = fetchFromGitHub {
    owner = "phacility";
    repo = "libphutil";
    rev = "3215e4e291ed4468faeed4542d47a571b5bc559a";
    sha256 = "0bbinaxny0j4iniz2grf0s9cysbl3x24yc32f3jra9mwsgh2v2zj";
  };
  arcanist = fetchFromGitHub {
    owner = "phacility";
    repo = "arcanist";
    rev = "2650e8627a20e1bfe334a4a2b787f44ef5d6ebc5";
    sha256 = "0x0xxiar202ypbgxh19swzjil546bbp8li4k5yrpvab55y8ymkd4";
  };
in
stdenv.mkDerivation {
  pname = "arcanist";
  version = "20180916";

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
