{ stdenv, fetchFromGitHub, pkgconfig, python2Packages, makeWrapper
, bash, libsamplerate, libsndfile, readline, eigen, celt
# Darwin Dependencies
, aften, AudioToolbox, CoreAudio, CoreFoundation

# Optional Dependencies
, dbus ? null, libffado ? null, alsaLib ? null
, libopus ? null

# Extra options
, prefix ? ""
}:

with stdenv.lib;
let
  inherit (python2Packages) python dbus-python;
  shouldUsePkg = pkg: if pkg != null && pkg.meta.available then pkg else null;

  libOnly = prefix == "lib";

  optDbus = if stdenv.isDarwin then null else shouldUsePkg dbus;
  optPythonDBus = if libOnly then null else shouldUsePkg dbus-python;
  optLibffado = if libOnly then null else shouldUsePkg libffado;
  optAlsaLib = if libOnly then null else shouldUsePkg alsaLib;
  optLibopus = shouldUsePkg libopus;
in
stdenv.mkDerivation rec {
  name = "${prefix}jack2-${version}";
  version = "1.9.12";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack2";
    rev = "v${version}";
    sha256 = "0ynpyn0l77m94b50g7ysl795nvam3ra65wx5zb46nxspgbf6wnkh";
  };

  nativeBuildInputs = [ pkgconfig python makeWrapper ];
  buildInputs = [ libsamplerate libsndfile readline eigen celt
    optDbus optPythonDBus optLibffado optAlsaLib optLibopus
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ aften AudioToolbox CoreAudio CoreFoundation ];

  # CoreFoundation 10.10 doesn't include CFNotificationCenter.h yet.
  patches = stdenv.lib.optionals stdenv.isDarwin [ ./darwin-cf.patch ];

  prePatch = ''
    substituteInPlace svnversion_regenerate.sh \
        --replace /bin/bash ${bash}/bin/bash
  '';

  # It looks like one of the frameworks depends on <CoreFoundation/CFAttributedString.h>
  # since frameworks are impure we also have to use the impure CoreFoundation here.
  # FIXME: remove when CoreFoundation is updated to 10.11
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_CFLAGS_COMPILE="-F${CoreFoundation}/Library/Frameworks $NIX_CFLAGS_COMPILE"
  '';

  configurePhase = ''
    runHook preConfigure

    python waf configure --prefix=$out \
      ${optionalString (optDbus != null) "--dbus"} \
      --classic \
      ${optionalString (optLibffado != null) "--firewire"} \
      ${optionalString (optAlsaLib != null) "--alsa"} \
      --autostart=${if (optDbus != null) then "dbus" else "classic"} \

    runHook postConfigure
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
    homepage = http://jackaudio.org;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ goibhniu wkennington ];
  };
}
