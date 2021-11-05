{ lib, stdenvNoCC, fetchFromGitHub, jshon, electron_10
, runtimeShell, hyper-haskell-server, extra-packages ? [] }:

let
  binPath = lib.makeBinPath ([ hyper-haskell-server ] ++ extra-packages);
  electron = electron_10;
in stdenvNoCC.mkDerivation rec {
  pname = "hyper-haskell";
  version = "0.2.3.0";

  src = fetchFromGitHub {
    owner = "HeinrichApfelmus";
    repo = "hyper-haskell";
    rev = "v${version}";
    sha256 = "1nmkry4wh6a2dy98fcs81mq2p7zhxp1k0f4m3szr6fm3j1zwrd43";
  };

  propagatedBuildInputs = extra-packages;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/hyper-haskell/worksheets $out/share/applications $out/share/icons/hicolor/scalable/apps $out/share/mime/packages

    # Electron app
    cp -R app $out

    # Desktop Launcher
    cp resources/hyper-haskell.desktop $out/share/applications/hyper-haskell.desktop
    cp resources/icons/icon.svg $out/share/icons/hicolor/scalable/apps/hyper-haskell.svg
    cp resources/shared-mime-info.xml $out/share/mime/packages/hyper-haskell.xml

    # install example worksheets with backend set to nix
    for worksheet in "worksheets/"*.hhs; do
      ${jshon}/bin/jshon -e settings -s nix -i packageTool -p < $worksheet > $out/share/hyper-haskell/worksheets/`basename $worksheet`
    done

    # install electron wrapper script
    cat > $out/bin/hyper-haskell <<EOF
    #!${runtimeShell}
    export PATH="${binPath}:\$PATH"
    exec ${electron}/bin/electron $out/app "\$@"
    EOF
    chmod 755 $out/bin/hyper-haskell
  '';

  meta = with lib; {
    description = "The strongly hyped graphical interpreter for the Haskell programming language";
    homepage = "https://github.com/HeinrichApfelmus/hyper-haskell";
    license = licenses.bsd3;
    maintainers = [ maintainers.rvl ];
    # depends on electron-10.4.7 which is marked as insecure:
    # https://github.com/NixOS/nixpkgs/pull/142641#issuecomment-957358476
    broken = true;
  };
}
