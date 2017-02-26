{ stdenv, fetchFromGitHub, pkgconfig, python2Packages, makeWrapper
, bash, libsamplerate, libsndfile, readline, eigen, celt

# Optional Dependencies
, dbus ? null, libffado ? null, alsaLib ? null
, libopus ? null

# Extra options
, prefix ? ""
}:

with stdenv.lib;
let
  inherit (python2Packages) python dbus-python;
  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  libOnly = prefix == "lib";

  optDbus = shouldUsePkg dbus;
  optPythonDBus = if libOnly then null else shouldUsePkg dbus-python;
  optLibffado = if libOnly then null else shouldUsePkg libffado;
  optAlsaLib = if libOnly then null else shouldUsePkg alsaLib;
  optLibopus = shouldUsePkg libopus;
in
stdenv.mkDerivation rec {
  name = "${prefix}jack2-unstable-${version}";
  version = "2017-02-23";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack2";
    rev = "4cf826c82c8f865c281833f92f8182d457277b3a";
    sha256 = "100pkc324m57ci3fb99d3api6wh6g58lya6ssly9hxyhdsa3i7bk";
  };

  nativeBuildInputs = [ pkgconfig python makeWrapper ];
  buildInputs = [
    python

    libsamplerate libsndfile readline eigen celt

    optDbus optPythonDBus optLibffado optAlsaLib optLibopus
  ];

  patchPhase = ''
    substituteInPlace svnversion_regenerate.sh --replace /bin/bash ${bash}/bin/bash
  '';

  configurePhase = ''
    python waf configure --prefix=$out \
      ${optionalString (optDbus != null) "--dbus"} \
      --classic \
      ${optionalString (optLibffado != null) "--firewire"} \
      ${optionalString (optAlsaLib != null) "--alsa"} \
      --autostart=${if (optDbus != null) then "dbus" else "classic"} \
  '';

  buildPhase = ''
    python waf build
  '';

  installPhase = ''
    python waf install
  '' + (if libOnly then ''
    rm -rf $out/{bin,share}
    rm -rf $out/lib/{jack,libjacknet*,libjackserver*}
  '' else ''
    wrapProgram $out/bin/jack_control --set PYTHONPATH $PYTHONPATH
  '');

  meta = {
    description = "JACK audio connection kit, version 2 with jackdbus";
    homepage = "http://jackaudio.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ goibhniu wkennington ];
  };
}
