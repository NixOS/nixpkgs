{ stdenv, callPackage, fetchurl, makeWrapper
# Begin libraries
, alsaLib, libX11, libXcursor, libXinerama, libXrandr, libXi
# Begin download parameters
, username ? ""
, password ? ""
}:

let
  version = "0.12.20";

  fetch = callPackage ./fetch.nix { username = username; password = password; };
  arch = if stdenv.system == "x86_64-linux" then "x64"
         else if stdenv.system == "i686-linux" then "x32"
         else abort "Unsupported platform";

  variants = {
    x64 = {
      url = "https://www.factorio.com/get-download/${version}/alpha/linux64";
      sha256 = "1xpzrx3q678519qgjl92fxn3qv55hd188x9jp6dcfk2ljhi1gmqk";
    };

    x32 = {
      url = "https://www.factorio.com/get-download/${version}/alpha/linux32";
      sha256 = "1dl1dsp4nni5nda437ckyw1ss6w168g19v51h7cdvb3cgsdb7sab";
    };
  };
in

stdenv.mkDerivation rec {
  name = "factorio-${version}";

  src = fetch variants.${arch};

  libPath = stdenv.lib.makeLibraryPath [
    alsaLib
    libX11
    libXcursor
    libXinerama
    libXrandr
    libXi
  ];

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/factorio}
    cp -a bin/${arch}/factorio $out/bin/factorio.${arch}
    cp -a doc-html data $out/share/factorio/

    # Fortunately, Factorio already supports system-wide installs.
    # Unfortunately it's a bit inconvenient to set the paths.
    cat > $out/share/factorio/config-base.cfg <<EOF
use-system-read-write-data-directories=false
[path]
read-data=$out/share/factorio/data/
EOF

    cat > $out/share/factorio/update-config.sh <<EOF
if [[ -e ~/.factorio/config.cfg ]]; then
  # Config file exists, but may have wrong path.
  # Try to edit it. I'm sure this is perfectly safe and will never go wrong.
  sed -i 's|^read-data=.*|read-data=$out/share/factorio/data/|' ~/.factorio/config.cfg
else
  # Config file does not exist. Phew.
  install -D $out/share/factorio/config-base.cfg ~/.factorio/config.cfg
fi
EOF
    chmod a+x $out/share/factorio/update-config.sh

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/bin/factorio.${arch}

    makeWrapper $out/bin/factorio.${arch} $out/bin/factorio \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:$libPath \
      --run "$out/share/factorio/update-config.sh" \
      --add-flags "-c \$HOME/.factorio/config.cfg"
  '';

  meta = {
    description = "A game in which you build and maintain factories";
    longDescription = ''
      Factorio is a game in which you build and maintain factories.

      You will be mining resources, researching technologies, building
      infrastructure, automating production and fighting enemies. Use your
      imagination to design your factory, combine simple elements into
      ingenious structures, apply management skills to keep it working and
      finally protect it from the creatures who don't really like you.

      Factorio has been in development since spring of 2012 and it is
      currently in late alpha.
    '';
    homepage = https://www.factorio.com/;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.Baughn ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
