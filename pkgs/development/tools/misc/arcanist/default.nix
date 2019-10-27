{ stdenv, fetchFromGitHub, php, flex, makeWrapper }:

let
  libphutil = fetchFromGitHub {
    owner = "phacility";
    repo = "libphutil";
    rev = "39ed96cd818aae761ec92613a9ba0800824d0ab0";
    sha256 = "1w55avn056kwa4gr25h09b7xhvyp397myrfzlmd1ggx7vj87vw1q";
  };
  arcanist = fetchFromGitHub {
    owner = "phacility";
    repo = "arcanist";
    rev = "3cdfe1fff806d2b54a2df631cf90193e518f42b7";
    sha256 = "1dngq8p4y4hln87hhgdm6hv68ld626j57lifw0821rvpnnmspw6j";
  };
in
stdenv.mkDerivation {
  pname = "arcanist";
  version = "20190905";

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
