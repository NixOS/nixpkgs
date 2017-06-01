{ stdenv, lib, fetchurl, intltool, pkgconfig, pythonPackages, bluez, polkit, gtk3
, obex_data_server, xdg_utils, libnotify, dnsmasq, dhcp
, hicolor_icon_theme, librsvg, wrapGAppsHook
, withPulseAudio ? true, libpulseaudio }:

let
  binPath = lib.makeBinPath [ xdg_utils dnsmasq dhcp ];

in stdenv.mkDerivation rec {
  name = "blueman-${version}";
  version = "2.0.4";

  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${name}.tar.xz";
    sha256 = "03s305mbc57nl3sq5ywh9casz926k4aqnylgaidli8bmgz1djbg9";
  };

  nativeBuildInputs = [ intltool pkgconfig pythonPackages.wrapPython pythonPackages.cython wrapGAppsHook ];

  buildInputs = [ bluez gtk3 pythonPackages.python libnotify librsvg hicolor_icon_theme ]
                ++ pythonPath
                ++ lib.optional withPulseAudio libpulseaudio;

  postPatch = lib.optionalString withPulseAudio ''
    sed -i 's,CDLL(",CDLL("${libpulseaudio.out}/lib/,g' blueman/main/PulseAudioUtils.py
  '';

  pythonPath = with pythonPackages; [ dbus-python pygobject3 pycairo ];

  propagatedUserEnvPkgs = [ obex_data_server ];

  configureFlags = [ (lib.enableFeature withPulseAudio "pulseaudio") ];

  preFixup = ''
    makeWrapperArgs="--prefix PATH ':' ${binPath}"
    wrapPythonProgramsIn "$out/bin" "$pythonPath"
    wrapPythonProgramsIn "$out/libexec" "$pythonPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/blueman-project/blueman";
    description = "GTK+-based Bluetooth Manager";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
