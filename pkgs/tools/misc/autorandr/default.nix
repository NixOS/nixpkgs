{ fetchgit, stdenv, disper ? null, xrandr, xdpyinfo }:

let
  rev = "4f5e2401ef";
in
  stdenv.mkDerivation {
    name = "autorandr-${rev}";

    src = fetchgit {
      inherit rev;
      url = "https://github.com/wertarbyte/autorandr.git";
    };

    patchPhase = ''
      substituteInPlace "autorandr" \
        --replace "/usr/bin/xrandr" "${xrandr}/bin/xrandr" \
        --replace "/usr/bin/xdpyinfo" "${xdpyinfo}/bin/xdpyinfo"
    '' + stdenv.lib.optionalString (disper != null) ''
      substituteInPlace "autorandr"
        --replace "/usr/bin/disper" "${disper}/bin/disper"
    '';

    installPhase = ''
      mkdir -p "$out/etc/bash_completion.d"
      cp -v bash_completion/autorandr "$out/etc/bash_completion.d"
      mkdir -p "$out/bin"
      cp -v autorandr auto-disper $out/bin
    '';

    meta = {
      description = "Autorandr, automatic display configuration selector based on connected devices";
      homepage = https://github.com/wertarbyte/autorandr;
    };
  }
