{ config, stdenv, lib, fetchurl, intltool, pkgconfig, python3Packages, bluez, gtk3
, obex_data_server, xdg_utils, dnsmasq, dhcp, libappindicator, iproute
, gnome3, librsvg, wrapGAppsHook, gobject-introspection
, withNetworkManager ?
    config.networking.networkmanager.enable or false, networkmanager
, withPulseAudio ? config.pulseaudio or stdenv.isLinux, libpulseaudio }:

let
  pythonPackages = python3Packages;
  binPath = lib.makeBinPath [ xdg_utils dnsmasq dhcp iproute ];

in stdenv.mkDerivation rec {
  pname = "blueman";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "1hyvc5x97j8b4kvwzh58zzlc454d0h0hk440zbg8f5as9qrv5spi";
  };

  nativeBuildInputs = [
    gobject-introspection intltool pkgconfig pythonPackages.cython
    pythonPackages.wrapPython wrapGAppsHook
  ];

  buildInputs = [ bluez gtk3 pythonPackages.python librsvg
                  gnome3.adwaita-icon-theme iproute libappindicator ]
                ++ pythonPath
                ++ lib.optional withPulseAudio libpulseaudio
                ++ lib.optional withNetworkManager networkmanager;

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

  postFixup = ''
    makeWrapperArgs="--prefix PATH ':' ${binPath}"
    # This mimics ../../../development/interpreters/python/wrap.sh
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
    wrapPythonProgramsIn "$out/libexec" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = https://github.com/blueman-project/blueman;
    description = "GTK-based Bluetooth Manager";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
