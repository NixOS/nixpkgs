{ fetchgit
, stdenv
, enableXRandr ? true, xrandr ? null
, enableDisper ? false, disper ? null
, xdpyinfo }:

assert enableXRandr -> xrandr != null;
assert enableDisper -> disper != null;

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
        --replace "/usr/bin/xrandr" "${if enableXRandr then xrandr else "/nowhere"}/bin/xrandr" \
        --replace "/usr/bin/disper" "${if enableDisper then disper else "/nowhere"}/bin/disper" \
        --replace "/usr/bin/xdpyinfo" "${xdpyinfo}/bin/xdpyinfo"
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
      maintainer = [ stdenv.lib.maintainers.coroa ];
    };
  }
