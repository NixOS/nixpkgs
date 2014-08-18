{ stdenv, fetchurl, flex, bison, ncurses, buddy, tecla, libsigsegv, gmpxx, makeWrapper }:

let
  # Banner depends on two separate libraries. Adding those libraries to
  # the top-level seems like overkill, though, because no other tools
  # seems to use them. So we'll build them within this expression.
  mkDerivation = name: hash: deriv: stdenv.mkDerivation (deriv // {
    inherit name;

    src = fetchurl {
      url = "http://shh.thathost.com/pub-unix/files/${name}.tar.gz";
      sha256 = hash;
    };

    configurePhase = "make dep";

    buildPhase = "make OPTIM='-DNDEBUG -O3'";

    installPhase = ''
      make INSTBASEDIR=$out install
      if [ -d $out/man ]; then
        mkdir -p $out/share
	mv -v $out/man $out/share/
      fi
    '';
  });

  shhopt = mkDerivation "shhopt-1.1.7" "bae94335124efa6fcc2f0a55cabd68c9c90be935bcdb8054d7e5188e0d5da679" {};

  shhmsg = mkDerivation "shhmsg-1.4.1" "f65d45d3a5e415b541a1975e13fe7c5b58e21df6e9306cc3f7901279a9f6d461" {};

in

mkDerivation "banner-1.3.2" "0dc0ac0667b2e884a7f5ad3e467af68cd0fd5917f8c9aa19188e6452aa1fc6d5" {
  buildInputs = [shhopt shhmsg];

  meta = {
    homepage = "http://shh.thathost.com/pub-unix/";
    description = "print large banners to ASCII terminals";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      An implementation of the traditional Unix-program used to display
      large characters.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
