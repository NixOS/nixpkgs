{ stdenv
, buildPythonApplication
, fetchFromGitHub
, atk
, gobject-introspection
, wrapGAppsHook
, click
, hidapi
, psutil
, pygobject3
}:

buildPythonApplication rec {
  pname = "cm-rgb";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "gfduszynski";
    repo = pname;
    rev = "v${version}";
    sha256 = "04brldaa2zpvzkcg43i5hpbj03d1nqrgiplm5nh4shn12cif19ag";
  };

  nativeBuildInputs = [
    atk

    # Populate GI_TYPELIB_PATH
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = [
    click
    hidapi
    psutil
    pygobject3
  ];

  postInstall = ''
    # Remove this line when/if this PR gets merged:
    # https://github.com/gfduszynski/cm-rgb/pull/43 
    install -m0755 scripts/cm-rgb-gui $out/bin/cm-rgb-gui

    mkdir -p $out/etc/udev/rules.d
    echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0051", TAG+="uaccess"' \
      > $out/etc/udev/rules.d/60-cm-rgb.rules
  '';

  meta = with stdenv.lib; {
    description = "Control AMD Wraith Prism RGB LEDs";
    longDescription = ''
      cm-rgb controls AMD Wraith Prism RGB LEDS.

      To permit non-root accounts to change use this utility on
      NixOS, add this package to <literal>services.udev.packages</literal>
      in <filename>configuration.nix</filename>.
    '';
    homepage = "https://github.com/gfduszynski/cm-rgb";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ danieldk ];
  };
}
