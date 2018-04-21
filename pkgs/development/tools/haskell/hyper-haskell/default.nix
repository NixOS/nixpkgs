{ stdenv, fetchFromGitHub, writeText, jshon, electron, hyper-haskell-server, extra-packages ? [] }:

let
  binPath = stdenv.lib.makeBinPath ([ hyper-haskell-server ] ++ extra-packages);

in stdenv.mkDerivation rec {
  name = "hyper-haskell-${version}";
  version = "0.1.0.2";

  src = fetchFromGitHub {
    owner = "HeinrichApfelmus";
    repo = "hyper-haskell";
    rev = "v${version}";
    sha256 = "1k38h7qx12z7463z8466pji0nwfkp4qkg7q83kns2mzmwmw5jnmb";
  };

  propagatedBuildInputs = extra-packages;

  buildCommand = ''
    mkdir -p $out/bin $out/share/hyper-haskell/worksheets $out/share/applications $out/share/icons/hicolor/scalable/apps $out/share/mime/packages

    # Electron app
    cp -R $src/app $out

    # Desktop Launcher
    cp $src/resources/hyper-haskell.desktop $out/share/applications/hyper-haskell.desktop
    cp $src/resources/icons/icon.svg $out/share/icons/hicolor/scalable/apps/hyper-haskell.svg
    cp $src/resources/shared-mime-info.xml $out/share/mime/packages/hyper-haskell.xml

    # install example worksheets with backend set to nix
    for worksheet in "$src/worksheets/"*.hhs; do
      ${jshon}/bin/jshon -e settings -s nix -i packageTool -p < $worksheet > $out/share/hyper-haskell/worksheets/`basename $worksheet`
    done

    # install electron wrapper script
    cat > $out/bin/hyper-haskell <<EOF
    #!${stdenv.shell}
    export PATH="${binPath}:\$PATH"
    exec ${electron}/bin/electron $out/app "\$@"
    EOF
    chmod 755 $out/bin/hyper-haskell
  '';

  meta = with stdenv.lib; {
    description = "The strongly hyped graphical interpreter for the Haskell programming language";
    homepage = "https://github.com/HeinrichApfelmus/hyper-haskell";
    license = licenses.bsd3;
    maintainers = [ maintainers.rvl ];
  };
}
