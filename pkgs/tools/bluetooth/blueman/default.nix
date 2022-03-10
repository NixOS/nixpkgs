{ config, stdenv, lib, fetchurl, intltool, pkg-config, python3Packages, bluez, gtk3
, obex_data_server, xdg-utils, dnsmasq, dhcp, libappindicator, iproute2
, gnome, librsvg, wrapGAppsHook, gobject-introspection, autoreconfHook
, networkmanager, withPulseAudio ? config.pulseaudio or stdenv.isLinux, libpulseaudio, fetchpatch }:

let
  pythonPackages = python3Packages;
  binPath = lib.makeBinPath [ xdg-utils dnsmasq dhcp iproute2 ];

in stdenv.mkDerivation rec {
  pname = "blueman";
  version = "2.2.4";

  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-VdY5/u2gtDsYplnmWYUhOlS0fcsTSPO07/tSONskJgI=";
  };

  nativeBuildInputs = [
    gobject-introspection intltool pkg-config pythonPackages.cython
    pythonPackages.wrapPython wrapGAppsHook
    autoreconfHook # drop when below patch is removed
  ];

  buildInputs = [ bluez gtk3 pythonPackages.python librsvg
                  gnome.adwaita-icon-theme iproute2 libappindicator networkmanager ]
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

  postFixup = ''
    makeWrapperArgs="--prefix PATH ':' ${binPath}"
    # This mimics ../../../development/interpreters/python/wrap.sh
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
    wrapPythonProgramsIn "$out/libexec" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/blueman-project/blueman";
    description = "GTK-based Bluetooth Manager";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
