<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, unstableGitUpdater
, coreutils
, util-linux
, gnugrep
, libnotify
, pwgen
, findutils
, gawk
, gnused
# wayland-only deps
, rofi-wayland
, pass-wayland
, wl-clipboard
, wtype
# x11-only deps
, rofi
, pass
, xclip
, xdotool
# backend selector
, backend ? "x11"
}:

assert lib.assertOneOf "backend" backend [ "x11" "wayland" ];

stdenv.mkDerivation {
  pname = "rofi-pass";
  version = "unstable-2023-07-04";
=======
{ lib, stdenv, fetchFromGitHub, pass, rofi, coreutils, util-linux, xdotool, gnugrep
, libnotify, pwgen, findutils, gawk, gnused, xclip, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "rofi-pass";
  version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "carnager";
    repo = "rofi-pass";
<<<<<<< HEAD
    rev = "fa16c0211d898d337e76397d22de4f92e2405ede";
    hash = "sha256-GGa8ZNHZZD/sU+oL5ekHXxAe3bpX/42x6zO2LJuypNw=";
=======
    rev = version;
    sha256 = "131jpcwyyzgzjn9lx4k1zn95pd68pjw4i41jfzcp9z9fnazyln5n";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a rofi-pass $out/bin/rofi-pass

    mkdir -p $out/share/doc/rofi-pass/
    cp -a config.example $out/share/doc/rofi-pass/config.example
  '';

<<<<<<< HEAD
  wrapperPath = lib.makeBinPath ([
=======
  wrapperPath = with lib; makeBinPath [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    coreutils
    findutils
    gawk
    gnugrep
    gnused
    libnotify
<<<<<<< HEAD
    pwgen
    util-linux
  ] ++ lib.optionals (backend == "x11") [
    rofi
    (pass.withExtensions (ext: [ ext.pass-otp ]))
    xclip
    xdotool
  ] ++ lib.optionals (backend == "wayland") [
    rofi-wayland
    (pass-wayland.withExtensions (ext: [ ext.pass-otp ]))
    wl-clipboard
    wtype
  ]);
=======
    (pass.withExtensions (ext: [ ext.pass-otp ]))
    pwgen
    rofi
    util-linux
    xclip
    xdotool
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/rofi-pass \
<<<<<<< HEAD
      --prefix PATH : "$wrapperPath" \
      --set-default ROFI_PASS_BACKEND ${if backend == "wayland" then "wtype" else "xdotool"} \
      --set-default ROFI_PASS_CLIPBOARD_BACKEND ${if backend == "wayland" then "wl-clipboard" else "xclip"}
  '';

  passthru.updateScript = unstableGitUpdater { };

=======
      --prefix PATH : "${wrapperPath}"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "A script to make rofi work with password-store";
    homepage = "https://github.com/carnager/rofi-pass";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ lilyinstarlight ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
