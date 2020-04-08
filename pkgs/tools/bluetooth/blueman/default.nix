{ config, stdenv, lib, fetchurl, intltool, pkgconfig, python3Packages, bluez, gtk3
, obex_data_server, xdg_utils, dnsmasq, dhcp, libappindicator, iproute
, gnome3, librsvg, wrapGAppsHook, gobject-introspection, autoreconfHook
, networkmanager, withPulseAudio ? config.pulseaudio or stdenv.isLinux, libpulseaudio, fetchpatch }:

let
  pythonPackages = python3Packages;
  binPath = lib.makeBinPath [ xdg_utils dnsmasq dhcp iproute ];

in stdenv.mkDerivation rec {
  pname = "blueman";
  version = "2.1.2";

  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "0k49hgyglsrlszckjzrvlsdm9ysns3qgvczgcmwaz02vvwnb4zai";
  };

  nativeBuildInputs = [
    gobject-introspection intltool pkgconfig pythonPackages.cython
    pythonPackages.wrapPython wrapGAppsHook
    autoreconfHook # drop when below patch is removed
  ];

  buildInputs = [ bluez gtk3 pythonPackages.python librsvg
                  gnome3.adwaita-icon-theme iproute libappindicator networkmanager ]
                ++ pythonPath
                ++ lib.optional withPulseAudio libpulseaudio;

  patches = [
    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://github.com/blueman-project/blueman/commit/ae2be5a70cdea1d1aa0e3ab1c85c1d3a0c4affc6.patch";
      sha256 = "0nb6jzlxhgjvac52cjwi0pi40b8v4h6z6pwz5vkyfmaj86spygg3";
      excludes = [
        "meson.build"
        "Dependencies.md"
      ];
    })
  ];

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
