{ config, stdenv, lib, fetchurl, intltool, pkg-config, python3Packages, bluez, gtk3
<<<<<<< HEAD
, obex_data_server, xdg-utils, dnsmasq, dhcpcd, iproute2
=======
, obex_data_server, xdg-utils, dnsmasq, dhcp, libappindicator, iproute2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gnome, librsvg, wrapGAppsHook, gobject-introspection
, networkmanager, withPulseAudio ? config.pulseaudio or stdenv.isLinux, libpulseaudio }:

let
  pythonPackages = python3Packages;

in stdenv.mkDerivation rec {
  pname = "blueman";
<<<<<<< HEAD
  version = "2.3.5";

  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-stIa/fd6Bs2G2vVAJAb30qU0WYF+KeC+vEkR1PDc/aE=";
=======
  version = "2.3.4";

  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-wgYzghQ38yydPRkOzXDR4vclXXSn1pefInEb3C5WAVI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    gobject-introspection intltool pkg-config pythonPackages.cython
    pythonPackages.wrapPython wrapGAppsHook
  ];

  buildInputs = [ bluez gtk3 pythonPackages.python librsvg
                  gnome.adwaita-icon-theme iproute2 networkmanager ]
                ++ pythonPath
                ++ lib.optional withPulseAudio libpulseaudio;

  postPatch = lib.optionalString withPulseAudio ''
    sed -i 's,CDLL(",CDLL("${libpulseaudio.out}/lib/,g' blueman/main/PulseAudioUtils.py
  '';

  pythonPath = with pythonPackages; [ pygobject3 pycairo ];

  propagatedUserEnvPkgs = [ obex_data_server ];

  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
    (lib.enableFeature withPulseAudio "pulseaudio")
  ];

  makeWrapperArgs = [
<<<<<<< HEAD
    "--prefix PATH ':' ${lib.makeBinPath [ dnsmasq dhcpcd iproute2 ]}"
=======
    "--prefix PATH ':' ${lib.makeBinPath [ dnsmasq dhcp iproute2 ]}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--suffix PATH ':' ${lib.makeBinPath [ xdg-utils ]}"
  ];

  postFixup = ''
    # This mimics ../../../development/interpreters/python/wrap.sh
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
    wrapPythonProgramsIn "$out/libexec" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/blueman-project/blueman";
    description = "GTK-based Bluetooth Manager";
    license = licenses.gpl3;
    platforms = platforms.linux;
<<<<<<< HEAD
    changelog = "https://github.com/blueman-project/blueman/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ abbradar ];
  };
}
