{ stdenv, fetchFromGitHub, pkgconfig, pythonPackages, makeWrapper
, bash, libsamplerate, libsndfile, readline

# Optional Dependencies
, dbus ? null, libffado ? null, alsaLib ? null
, libopus ? null

# Extra options
, prefix ? ""
}:

with stdenv.lib;
let
  inherit (pythonPackages) python dbus-python;
  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  libOnly = prefix == "lib";

  optDbus = shouldUsePkg dbus;
  optPythonDBus = if libOnly then null else shouldUsePkg dbus-python;
  optLibffado = if libOnly then null else shouldUsePkg libffado;
  optAlsaLib = if libOnly then null else shouldUsePkg alsaLib;
  optLibopus = shouldUsePkg libopus;
in
stdenv.mkDerivation rec {
  name = "${prefix}jack2-${version}";
  version = "2015-09-03";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack2";
    rev = "2e8c5502c692a25f1c0213f3f7eeba1f4434da3c";
    sha256 = "0r1xdshm251yqb748r5l5f6xpznhwlqyyxkky7vgx5m2q51qb0a1";
  };

  nativeBuildInputs = [ pkgconfig python makeWrapper ];
  buildInputs = [
    python

    libsamplerate libsndfile readline

    optDbus optPythonDBus optLibffado optAlsaLib optLibopus
  ];

  patchPhase = ''
    substituteInPlace svnversion_regenerate.sh --replace /bin/bash ${bash}/bin/bash
  '';

  configurePhase = ''
    python waf configure --prefix=$out \
      ${optionalString (optDbus != null) "--dbus"} \
      --classic \
      --profile \
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
