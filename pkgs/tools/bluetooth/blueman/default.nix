{ stdenv, lib, fetchurl, intltool, pkgconfig, pythonPackages, bluez, polkit, gtk3
, obex_data_server, xdg_utils, libnotify, dconf, gsettings_desktop_schemas, dnsmasq, dhcp
, withPulseAudio ? true, libpulseaudio }:

let
  binPath = lib.makeBinPath [ xdg_utils dnsmasq dhcp ];

in stdenv.mkDerivation rec {
  name = "blueman-${version}";
  version = "2.0.3";
   
  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${name}.tar.xz";
    sha256 = "09aqlk4c2qzqpmyf7b40sic7d45c1l8fyrb9f3s22b8w83j0adi4";
  };

  nativeBuildInputs = [ intltool pkgconfig pythonPackages.wrapPython pythonPackages.cython ];

  buildInputs = [ bluez gtk3 pythonPackages.python libnotify dconf gsettings_desktop_schemas ]
                ++ pythonPath
                ++ lib.optional withPulseAudio libpulseaudio;

  postPatch = lib.optionalString withPulseAudio ''
    sed -i 's,CDLL(",CDLL("${libpulseaudio}/lib/,g' blueman/main/PulseAudioUtils.py
  '';

  pythonPath = with pythonPackages; [ dbus pygobject3 ];

  propagatedUserEnvPkgs = [ obex_data_server dconf ];

  configureFlags = [ (lib.enableFeature withPulseAudio "pulseaudio") ];

  postFixup = ''
    makeWrapperArgs="\
      --prefix PATH ':' ${binPath} \
      --prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH \
      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
      --prefix GIO_EXTRA_MODULES : ${dconf}/lib/gio/modules"
    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = https://github.com/blueman-project;
    description = "GTK+-based Bluetooth Manager";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
