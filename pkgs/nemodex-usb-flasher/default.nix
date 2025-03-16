{
  pkgs ? import (builtins.fetchTarball {
    url = "https://nixos.org/channels/nixos-24.05/nixexprs.tar.xz";
    sha256 = "06g8b0ga935dnziyzhxznwcx1vb2clc84hcxwrcqb26lgjgwsgbf";
  }) { },
}:

pkgs.stdenv.mkDerivation {
  pname = "nemodex-usb-flasher";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [
    pkgs.python3
    pkgs.makeWrapper
  ];

  buildInputs = [
    pkgs.python3Packages.tkinter
    pkgs.python3Packages.psutil
    pkgs.libglvnd
    pkgs.qt5.qtbase
    pkgs.qt5.qtx11extras
    pkgs.xorg.libxcb
    pkgs.xorg.libX11
    pkgs.xorg.libXrender
    pkgs.xorg.libXi
    pkgs.xorg.libXtst
  ];

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/flasher.py $out/bin/
    cp $src/nemodex-usb-flasher.sh $out/bin/
    chmod +x $out/bin/flasher.py
    chmod +x $out/bin/nemodex-usb-flasher.sh
    ln -s $out/bin/nemodex-usb-flasher.sh $out/bin/nemodex-usb-flasher
  '';

  postInstall = ''
    wrapProgram $out/bin/nemodex-usb-flasher \
      --prefix PYTHONPATH : ${pkgs.python3Packages.tkinter}/lib/python3.11/site-packages \
      --set QT_QPA_PLATFORM_PLUGIN_PATH ${pkgs.qt5.qtbase}/lib/qt-5.15/plugins \
      --set QT_PLUGIN_PATH ${pkgs.qt5.qtbase}/lib/qt-5.15/plugins \
      --set QT_QPA_PLATFORM xcb \
      --set LD_LIBRARY_PATH ${pkgs.qt5.qtbase}/lib:${pkgs.xorg.libxcb}/lib:${pkgs.libglvnd}/lib:$LD_LIBRARY_PATH
  '';

  shellHook = ''
    # Run the flasher script when entering the shell
    $out/bin/nemodex-usb-flasher
  '';

  meta = with pkgs.lib; {
    description = "Nemodex USB Flasher";
    license = licenses.mit;
    maintainers = with maintainers; [ maintainers.nemodex ];
  };
}
