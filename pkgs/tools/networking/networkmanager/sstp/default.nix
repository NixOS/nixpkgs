{ lib, stdenv
, autoreconfHook
, fetchFromGitHub
, fetchpatch
, file
, glib
, gnome
, gtk3
, intltool
, libnma
, libsecret
, networkmanager
, pkg-config
, ppp
, sstp
, substituteAll
, withGnome ? true }:

let
  pname = "NetworkManager-sstp";
  version = "unstable-2020-04-20";
in stdenv.mkDerivation {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchFromGitHub {
    owner = "enaess";
    repo = "network-manager-sstp";
    rev = "735d8ca078f933e085029f60a737e3cf1d8c29a8";
    sha256 = "0aahfhy2ch951kzj6gnd8p8hv2s5yd5y10wrmj68djhnx2ml8cd3";
  };

  buildInputs = [ sstp networkmanager glib ppp ]
    ++ lib.optionals withGnome [ gtk3 libsecret libnma ];

  nativeBuildInputs = [ file intltool autoreconfHook pkg-config ];

  postPatch = ''
    sed -i 's#/sbin/pppd#${ppp}/bin/pppd#' src/nm-sstp-service.c
    sed -i 's#/sbin/sstpc#${sstp}/bin/sstpc#' src/nm-sstp-service.c
  '';

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  preConfigure = "intltoolize";
  configureFlags = [
    "--without-libnm-glib"
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-sstp";
    };
    networkManagerPlugin = "VPN/nm-sstp-service.name";
  };

  meta = with lib; {
    description = "NetworkManager's sstp plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
