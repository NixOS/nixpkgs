{ lib, stdenv, fetchFromGitHub, fetchpatch2, pkg-config, python3Packages, makeWrapper
, libsamplerate, eigen, celt
, wafHook
, gitUpdater
, testers

# Darwin Dependencies
, aften, AudioUnit, CoreAudio, libobjc, Accelerate

# Optional Dependencies
, dbus ? null, libffado ? null, alsa-lib ? null
, libopus ? null, systemd ? null, db ? null

# Optional build-time dependencies
, doxygen ? null

# Use prefix = "lib" to build a minimal libraries-only package
, prefix ? ""
}:

stdenv.mkDerivation (finalAttrs: let
  inherit (python3Packages) python dbus-python;
  shouldUsePkg = pkg: pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg;
  enabled = pkg: pkg != null && lib.elem pkg finalAttrs.buildInputs;
  libOnly = prefix == "lib";
  withJackDbus = !libOnly && enabled dbus;
  withDevDoc = doxygen != null;
  devDocDir = "share/doc/${finalAttrs.pname}/html";
in {
  pname = "${prefix}jack2";
  version = "1.9.22";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "jack2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Cslfys5fcZDy0oee9/nM5Bd1+Cg4s/ayXjJJOSQCL4E=";
  };

  outputs = [ "out" "dev" ] ++ lib.optional withDevDoc "devdoc";

  nativeBuildInputs = [ pkg-config python makeWrapper wafHook doxygen ];
  buildInputs = lib.filter shouldUsePkg (lib.concatLists [
    [ libsamplerate eigen celt libopus db ]
    (lib.optionals (!libOnly) [
      dbus-python libffado alsa-lib systemd
    ])
    (if stdenv.isDarwin then [
      aften AudioUnit CoreAudio Accelerate libobjc
    ] else [
      dbus
    ])
  ]);

  patches = [
    (fetchpatch2 {
      # Python 3.12 support
      name = "jack2-waf2.0.26.patch";
      url = "https://github.com/jackaudio/jack2/commit/250420381b1a6974798939ad7104ab1a4b9a9994.patch";
      hash = "sha256-M/H72lLTeddefqth4BSkEfySZRYMIzLErb7nIgVN0u8=";
    })
  ];

  dontAddWafCrossFlags = true;

  wafConfigureFlags = [
    "--pkgconfigdir=${placeholder "dev"}/lib/pkgconfig"
    "--classic"
    "--autostart=${if withJackDbus then "dbus" else "classic"}"
  ] ++ lib.optionals withJackDbus [
    "--dbus"
  ] ++ lib.optionals withDevDoc [
    "--doxygen"
    "--htmldir=${placeholder "devdoc"}/${devDocDir}"
  ];

  postInstall = ''
    _multioutJack2Bin() {
      local bin="$1"
      moveToOutput bin "$bin"
      moveToOutput lib/jack "$bin"
      moveToOutput "lib/libjacknet*" "$bin"
      moveToOutput "lib/libjackserver*" "$bin"
      moveToOutput share/dbus-1 "$bin"
      moveToOutput share/man "$bin"
    }
  '' + (if libOnly then ''
    _multioutJack2Bin REMOVE
    sed -i -e '/^server_libs/d' "$dev/lib/pkgconfig/jack.pc"
  '' else lib.optionalString (withJackDbus != null) ''
    wrapProgram $out/bin/jack_control --set PYTHONPATH $PYTHONPATH
  '');

  postFixup = ''
    substituteInPlace "$dev/lib/pkgconfig/jack.pc" \
      --replace "$out/include" "$dev/include"

    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput ${devDocDir} "$devdoc"
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };
  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "JACK audio connection kit, version 2 with jackdbus";
    homepage = "https://jackaudio.org";
    license = licenses.gpl2Plus;
    pkgConfigModules = [ "jack" ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
