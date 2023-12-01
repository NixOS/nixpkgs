{ config, stdenv, lib, fetchurl, intltool, pkg-config, python3Packages, bluez, gtk3
, obex_data_server, xdg-utils, dnsmasq, dhcpcd, iproute2
, gnome, librsvg, wrapGAppsHook, gobject-introspection
, networkmanager, withPulseAudio ? config.pulseaudio or stdenv.isLinux, libpulseaudio }:

let
  pythonPackages = python3Packages;

in stdenv.mkDerivation rec {
  pname = "blueman";
  version = "2.3.5";

  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-stIa/fd6Bs2G2vVAJAb30qU0WYF+KeC+vEkR1PDc/aE=";
  };

  nativeBuildInputs = [
    gobject-introspection intltool pkg-config pythonPackages.cython
    pythonPackages.wrapPython wrapGAppsHook
  ];

  buildInputs = [ bluez gtk3 pythonPackages.python librsvg
                  gnome.adwaita-icon-theme networkmanager ]
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
    # Don't check for runtime dependency `ip` during the configure
    "--disable-runtime-deps-check"
    (lib.enableFeature withPulseAudio "pulseaudio")
  ];

  makeWrapperArgs = [
    "--prefix PATH ':' ${lib.makeBinPath [ dnsmasq dhcpcd iproute2 ]}"
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
    changelog = "https://github.com/blueman-project/blueman/releases/tag/${version}";
    maintainers = with maintainers; [ abbradar ];
  };
}
