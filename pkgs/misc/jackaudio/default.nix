{ lib, stdenv, fetchFromGitHub, pkg-config, python3Packages, makeWrapper
, libsamplerate, libsndfile, readline, eigen, celt
, wafHook
# Darwin Dependencies
, aften, AudioUnit, CoreAudio, libobjc, Accelerate

# Optional Dependencies
, dbus ? null, libffado ? null, alsa-lib ? null
, libopus ? null

# Extra options
, prefix ? ""

, testers
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
stdenv.mkDerivation (finalAttrs: {
  pname = "${prefix}jack2";
  version = "1.9.22";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Cslfys5fcZDy0oee9/nM5Bd1+Cg4s/ayXjJJOSQCL4E=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config python makeWrapper wafHook ];
  buildInputs = [ libsamplerate libsndfile readline eigen celt
    optDbus optPythonDBus optLibffado optAlsaLib optLibopus
  ] ++ lib.optionals stdenv.isDarwin [
    aften AudioUnit CoreAudio Accelerate libobjc
  ];

  postPatch = ''
    patchShebangs --build svnversion_regenerate.sh
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

  postFixup = ''
    substituteInPlace "$dev/lib/pkgconfig/jack.pc" \
      --replace "$out/include" "$dev/include"
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "JACK audio connection kit, version 2 with jackdbus";
    homepage = "https://jackaudio.org";
    license = licenses.gpl2Plus;
    pkgConfigModules = [ "jack" ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ goibhniu ];
  };
})
