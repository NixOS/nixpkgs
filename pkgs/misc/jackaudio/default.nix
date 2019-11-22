{ stdenv, fetchFromGitHub, pkgconfig, python2Packages, makeWrapper
, fetchpatch
, bash, libsamplerate, libsndfile, readline, eigen, celt
, wafHook
# Darwin Dependencies
, aften, AudioUnit, CoreAudio, libobjc, Accelerate

# Optional Dependencies
, dbus ? null, libffado ? null, alsaLib ? null
, libopus ? null

# Extra options
, prefix ? ""
}:

with stdenv.lib;
let
  inherit (python2Packages) python dbus-python;
  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (stdenv.lib.meta.platformMatch stdenv.hostPlatform) pkg.meta.platforms then pkg else null;

  libOnly = prefix == "lib";

  optDbus = if stdenv.isDarwin then null else shouldUsePkg dbus;
  optPythonDBus = if libOnly then null else shouldUsePkg dbus-python;
  optLibffado = if libOnly then null else shouldUsePkg libffado;
  optAlsaLib = if libOnly then null else shouldUsePkg alsaLib;
  optLibopus = shouldUsePkg libopus;
in
stdenv.mkDerivation rec {
  name = "${prefix}jack2-${version}";
  version = "1.9.13";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack2";
    rev = "v${version}";
    sha256 = "1dnq75ylcv3npsyvzzkj0g8mdnzwis1whc2pk6s5hkcc1bgvv2xy";
  };

  nativeBuildInputs = [ pkgconfig python makeWrapper wafHook ];
  buildInputs = [ libsamplerate libsndfile readline eigen celt
    optDbus optPythonDBus optLibffado optAlsaLib optLibopus
  ] ++ optionals stdenv.isDarwin [
    aften AudioUnit CoreAudio Accelerate libobjc
  ];

  prePatch = ''
    substituteInPlace svnversion_regenerate.sh \
        --replace /bin/bash ${bash}/bin/bash
  '';

  wafConfigureFlags = [
    "--classic"
    "--autostart=${if (optDbus != null) then "dbus" else "classic"}"
  ] ++ optional (optDbus != null) "--dbus"
    ++ optional (optLibffado != null) "--firewire"
    ++ optional (optAlsaLib != null) "--alsa";

  postInstall = (if libOnly then ''
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
    maintainers = with maintainers; [ goibhniu ];
  };
}
