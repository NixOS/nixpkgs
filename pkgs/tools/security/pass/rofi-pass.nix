{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  unstableGitUpdater,
  coreutils,
  util-linux,
  gnugrep,
  libnotify,
  pwgen,
  findutils,
  gawk,
  gnused,
  # wayland-only deps
  rofi-wayland,
  pass-wayland,
  wl-clipboard,
  wtype,
  # x11-only deps
  rofi,
  pass,
  xclip,
  xdotool,
  # backend selector
  backend ? "x11",
}:

assert lib.assertOneOf "backend" backend [
  "x11"
  "wayland"
];

stdenv.mkDerivation {
  pname = "rofi-pass";
  version = "2.0.2-unstable-2024-02-13";

  src = fetchFromGitHub {
    owner = "carnager";
    repo = "rofi-pass";
    rev = "8aa6b9293a8f0af267425326fa966966ca42085e";
    hash = "sha256-g/AuLYj0yvLCXFR3y9GbMiE6hDCPBeuFM145c2Ukvys=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a rofi-pass $out/bin/rofi-pass

    mkdir -p $out/share/doc/rofi-pass/
    cp -a config.example $out/share/doc/rofi-pass/config.example
  '';

  wrapperPath = lib.makeBinPath (
    [
      coreutils
      findutils
      gawk
      gnugrep
      gnused
      libnotify
      pwgen
      util-linux
    ]
    ++ lib.optionals (backend == "x11") [
      rofi
      (pass.withExtensions (ext: [ ext.pass-otp ]))
      xclip
      xdotool
    ]
    ++ lib.optionals (backend == "wayland") [
      rofi-wayland
      (pass-wayland.withExtensions (ext: [ ext.pass-otp ]))
      wl-clipboard
      wtype
    ]
  );

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/rofi-pass \
      --prefix PATH : "$wrapperPath" \
      --set-default ROFI_PASS_BACKEND ${if backend == "wayland" then "wtype" else "xdotool"} \
      --set-default ROFI_PASS_CLIPBOARD_BACKEND ${
        if backend == "wayland" then "wl-clipboard" else "xclip"
      }
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "A script to make rofi work with password-store";
    mainProgram = "rofi-pass";
    homepage = "https://github.com/carnager/rofi-pass";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ lilyinstarlight ];
  };
}
