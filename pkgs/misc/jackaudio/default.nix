{ lib, stdenv, fetchFromGitHub, pkg-config, python3Packages, makeWrapper
, bash, libsamplerate, libsndfile, readline, eigen, celt
, wafHook
# Darwin Dependencies
, aften, AudioUnit, CoreAudio, libobjc, Accelerate

# Optional Dependencies
, dbus ? null, libffado ? null, alsa-lib ? null
, libopus ? null

# Extra options
, prefix ? ""
}:

let
  inherit (python3Packages) python dbus-python;
  shouldUsePkg = pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

  libOnly = prefix == "lib";

  optDbus = if stdenv.isDarwin then null else shouldUsePkg dbus;
  optPythonDBus = if libOnly then null else shouldUsePkg dbus-python;
  optLibffado = if libOnly then null else shouldUsePkg libffado;
  optAlsaLib = if libOnly then null else shouldUsePkg alsa-lib;
  optLibopus = shouldUsePkg libopus;
in
stdenv.mkDerivation rec {
  pname = "${prefix}jack2";
  version = "1.9.19";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack2";
    rev = "v${version}";
    sha256 = "01s8i64qczxqawgrzrw19asaqmcspf5l2h3203xzg56wnnhhzcw7";
  };

  nativeBuildInputs = [ pkg-config python makeWrapper wafHook ];
  buildInputs = [ libsamplerate libsndfile readline eigen celt
    optDbus optPythonDBus optLibffado optAlsaLib optLibopus
  ] ++ lib.optionals stdenv.isDarwin [
    aften AudioUnit CoreAudio Accelerate libobjc
  ];

  prePatch = ''
    substituteInPlace svnversion_regenerate.sh \
        --replace /bin/bash ${bash}/bin/bash
  '';

  dontAddWafCrossFlags = true;
  wafConfigureFlags = [
    "--classic"
    "--autostart=${if (optDbus != null) then "dbus" else "classic"}"
  ] ++ lib.optional (optDbus != null) "--dbus"
    ++ lib.optional (optLibffado != null) "--firewire"
    ++ lib.optional (optAlsaLib != null) "--alsa";

  postInstall = (if libOnly then ''
    rm -rf $out/{bin,share}
    rm -rf $out/lib/{jack,libjacknet*,libjackserver*}
  '' else ''
    wrapProgram $out/bin/jack_control --set PYTHONPATH $PYTHONPATH
  '');

  meta = with lib; {
    description = "JACK audio connection kit, version 2 with jackdbus";
    homepage = "https://jackaudio.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ goibhniu ];
  };
}
