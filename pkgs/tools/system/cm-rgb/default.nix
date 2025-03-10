{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  atk,
  gobject-introspection,
  wrapGAppsHook3,
  click,
  hidapi,
  psutil,
  pygobject3,
}:

buildPythonApplication rec {
  pname = "cm-rgb";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "gfduszynski";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m0ZAjSLRzcjzygLEbvCiDd7krc1gRqTg1ZV4H/o2c68=";
  };

  nativeBuildInputs = [
    atk

    # Populate GI_TYPELIB_PATH
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    click
    hidapi
    psutil
    pygobject3
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2516", ATTR{idProduct}=="0051", TAG+="uaccess"' \
      > $out/etc/udev/rules.d/60-cm-rgb.rules
  '';

  meta = with lib; {
    description = "Control AMD Wraith Prism RGB LEDs";
    longDescription = ''
      cm-rgb controls AMD Wraith Prism RGB LEDS.

      To permit non-root accounts to use this utility on
      NixOS, add this package to <literal>services.udev.packages</literal>
      in <filename>configuration.nix</filename>.
    '';
    homepage = "https://github.com/gfduszynski/cm-rgb";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
