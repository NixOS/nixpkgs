{ stdenv, gmp, zlib, ncurses5 }:

let
  patchelf = libPath: if stdenv.isDarwin
    then ""
    else ''
          chmod u+w $SPAGO
          patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${libPath} $SPAGO
          chmod u-w $SPAGO
        '';

in stdenv.mkDerivation rec {
  pname = "spago";

  version = "0.8.5.0";

  src = if stdenv.isDarwin
    then builtins.fetchurl {
      url = "https://github.com/spacchetti/spago/releases/download/0.8.5.0/osx.tar.gz";
      sha256 = "0a6s4xpzdvbyh16ffcn0qsc3f9q15chg0qfaxhrgc8a7qg84ym5n";
    }
    else builtins.fetchurl {
      url = "https://github.com/spacchetti/spago/releases/download/0.8.5.0/linux.tar.gz";
      sha256 = "0r66pmjfwv89c1h71s95nkq9hgbk7b8h9sk05bfmhsx2gprnd3bq";
    };

  buildInputs = [ gmp zlib ncurses5 ];
  nativeBuildInputs = [ stdenv.cc.cc.lib ];

  libPath = stdenv.lib.makeLibraryPath (buildInputs ++ nativeBuildInputs);

  dontStrip = true;

  unpackPhase = ''
      mkdir -p $out/bin
      tar xf $src -C $out/bin

      SPAGO=$out/bin/spago
      ${patchelf libPath}


      mkdir -p $out/etc/bash_completion.d/
      $SPAGO --bash-completion-script $SPAGO > $out/etc/bash_completion.d/spago-completion.bash
    '';

  dontInstall = true;

  meta = with stdenv.lib; {
    description = "PureScript package manager and build tool powered by Dhall and package-sets";
    homepage = https://github.com/spacchetti/spago;
    license = licenses.bsd3;
    maintainers = with maintainers; [ shou ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
