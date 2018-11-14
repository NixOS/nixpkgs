{ stdenv, lib, fetchurl, intltool, pkgconfig, python3Packages, bluez, gtk3
, obex_data_server, xdg_utils, libnotify, dnsmasq, dhcp
, hicolor-icon-theme, librsvg, wrapGAppsHook, gobjectIntrospection
, withPulseAudio ? true, libpulseaudio }:

let
  pythonPackages = python3Packages;
  binPath = lib.makeBinPath [ xdg_utils dnsmasq dhcp ];

in stdenv.mkDerivation rec {
  name = "blueman-${version}";
  version = "2.0.6";

  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${name}.tar.xz";
    sha256 = "0bc1lfsjkbrg9f1jnw6mx7bp04x76ljy9g0rgx7n80vaj0hpz3bj";
  };

  nativeBuildInputs = [
    gobjectIntrospection intltool pkgconfig pythonPackages.cython
    pythonPackages.wrapPython wrapGAppsHook
  ];

  buildInputs = [ bluez gtk3 pythonPackages.python libnotify librsvg hicolor-icon-theme ]
                ++ pythonPath
                ++ lib.optional withPulseAudio libpulseaudio;

  postPatch = lib.optionalString withPulseAudio ''
    sed -i 's,CDLL(",CDLL("${libpulseaudio.out}/lib/,g' blueman/main/PulseAudioUtils.py
  '';

  pythonPath = with pythonPackages; [ dbus-python pygobject3 pycairo ];

  propagatedUserEnvPkgs = [ obex_data_server ];

  configureFlags = [ (lib.enableFeature withPulseAudio "pulseaudio") ];

  postFixup = ''
    makeWrapperArgs="--prefix PATH ':' ${binPath}"
    # This mimics ../../../development/interpreters/python/wrap.sh
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
    wrapPythonProgramsIn "$out/libexec" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = https://github.com/blueman-project/blueman;
    description = "GTK+-based Bluetooth Manager";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
