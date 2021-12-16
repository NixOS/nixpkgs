{ stdenv, fetchurl, lib, makeWrapper, xorg, writeText, qt5, libpulseaudio, python3Packages, fetchFromGitHub, makeDesktopItem }:
let 
  fetchPypi = python3Packages.fetchPypi;

  soundcard = python3Packages.buildPythonPackage rec {
    pname = "SoundCard";
    version = "0.4.1";
    
    src = python3Packages.fetchPypi{
      inherit version;
      inherit pname;
      sha256 = "1qmm3r1qi2hh42spc729fcxk0a3slywxw941vmjmaf400hd3ping";
    };
    preBuild = ''
      export LD_LIBRARY_PATH=${libpulseaudio}/lib
    '';
    # It tries to create a folder in /home
    doCheck = false;
    buildInputs = [libpulseaudio] ++ (with python3Packages; [ numpy cffi ]);
  };

  ite8291r3_ctl = python3Packages.buildPythonPackage rec {
    pname = "ite8291r3-ctl";
    version = "0.3";
    
    src = python3Packages.fetchPypi{
      inherit version;
      inherit pname;
      sha256 = "0clmpvaln8s7d47c9a4qfscfirhv5vizx0asiwvxwbsmii3mlr6q";
    };

    buildInputs = with python3Packages; [ pyusb ];
  };

  mss_patched = python3Packages.buildPythonPackage rec {
    pname = "mss";
    version = "6.1.0";
    
    src = python3Packages.fetchPypi{
      inherit version;
      inherit pname;
      sha256 = "152kz83cwdk94gh8q1g11iqs8hpyf4blpymrqzlpyrh57sghdgdf";
    };

    # By default it attempts to build Windows-only functionality
    prePatch = ''
      rm mss/windows.py
    '';
    # See: https://discourse.nixos.org/t/screenshot-with-mss-in-python-says-no-x11-library/14534/4
    postPatch = ''
      sed -i 's|ctypes.util.find_library("X11")|"${xorg.libX11}/lib/libX11.so"|' mss/linux.py
      sed -i 's|ctypes.util.find_library("Xrandr")|"${xorg.libXrandr}/lib/libXrandr.so"|' mss/linux.py
    '';
    # Skipping tests due to most relying on DISPLAY being set
    pythonImportsCheck = [ "mss" ];
  };

  udevRules = writeText "udev-rules" ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="048d", ATTRS{idProduct}=="ce00", GROUP="leds", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="048d", ATTRS{idProduct}=="6004", GROUP="leds", MODE:="0666"
  '';

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/salihmarangoz/system_tray_extensions/fc506f753df412d24650889cf9c7056ef480f6e2/icon.png";
    sha256 = "16bfradr507qdb2vw1jkgagq73hqalja03v3k585z40s2jvh0vxr";
  };

  desktopItem = makeDesktopItem {
    desktopName = "System Tray Extensions";
    genericName = "STE";
    categories = "Utility";
    exec = "ste";
    icon = icon;
    name = "ste";
    type = "Application";
  };
in
stdenv.mkDerivation rec {
  pname = "linux-laptop-system-tray-extensions";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "salihmarangoz";
    repo = "system_tray_extensions";
    rev = "fc506f753df412d24650889cf9c7056ef480f6e2";
    sha256 = "00jqpa7q874b09q3yp4xclb63hf360b245a9nrhrs2fswqd9rb2c";
  };

  pythonPath = with python3Packages; [
    pyqt5
    numpy
    pillow
    opencv3
    pygobject3
    dbus-python
    GitPython
    psutil
    matplotlib
    scipy
    wheel
    pynput
    pyusb
    cffi
    
    # Custom-built packages
    ite8291r3_ctl
    soundcard
    mss_patched
  ];

  nativeBuildInputs = [makeWrapper];
  
  patches = [
    ./state.patch
  ];

  buildPhase = ''
    # Just copy the source
    prefix=$out/app
    mkdir -p $prefix
    cp -r . $prefix
  '';

  installPhase = ''
    # Override the start script so it matches Nix's filesystem.
    echo "python3 $prefix/app.py" > $prefix/start.sh
    chmod a+x $prefix/start.sh
    makeWrapper $prefix/start.sh $out/bin/ste \
        --run "cd $prefix" \
        --run "mkdir -p \$HOME/.local/ste" \
        --prefix DYLD_LIBRARY_PATH : ${lib.makeLibraryPath [xorg.libX11]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [xorg.libX11]} \
        --prefix PYTHONPATH : ${python3Packages.makePythonPath pythonPath} \
        --prefix QT_QPA_PLATFORM_PLUGIN_PATH : ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms

    mkdir -p $out/lib/udev/rules.d
    cp ${udevRules} $out/lib/udev/rules.d/99-ite8291.rules
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = with lib; {
    description = "System tray toolbox for Linux laptops. Currently includes tools for contolling keyboard and lightbar leds but new functions will be added in the future";
    homepage = "https://github.com/salihmarangoz/system_tray_extensions";
    license = licenses.mit;
    maintainers = with maintainers; [ peterwilli ];
    platforms = platforms.linux;
  };
} 
