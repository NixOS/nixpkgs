{ fetchgit
, stdenv
, enableXRandr ? true, xrandr ? null
, enableDisper ? true, disper ? null
, python
, xdpyinfo }:

assert enableXRandr -> xrandr != null;
assert enableDisper -> disper != null;

let
  # Revision and date taken from the legacy tree, which still
  # supports disper:
  # https://github.com/phillipberndt/autorandr/tree/legacy
  rev = "59f6aec0bb72e26751ce285d079e085b7178e45d";
  date = "20150127";
in
  stdenv.mkDerivation {
    name = "autorandr-${date}";

    src = fetchgit {
      inherit rev;
      url = "https://github.com/phillipberndt/autorandr.git";
      sha256 = "0mnggsp42477kbzwwn65gi8y0rydk10my9iahikvs6n43lphfa1f";
    };

    patchPhase = ''
      substituteInPlace "autorandr" \
        --replace "/usr/bin/xrandr" "${if enableXRandr then xrandr else "/nowhere"}/bin/xrandr" \
        --replace "/usr/bin/disper" "${if enableDisper then disper else "/nowhere"}/bin/disper" \
        --replace "/usr/bin/xdpyinfo" "${xdpyinfo}/bin/xdpyinfo" \
        --replace "which xxd" "false" \
        --replace "python" "${python}/bin/python"
    '';

    installPhase = ''
      mkdir -p "$out/etc/bash_completion.d"
      cp -v bash_completion/autorandr "$out/etc/bash_completion.d"
      mkdir -p "$out/bin"
      cp -v autorandr auto-disper $out/bin
    '';

    meta = {
      description = "Automatic display configuration selector based on connected devices";
      homepage = https://github.com/wertarbyte/autorandr;
      maintainers = [ stdenv.lib.maintainers.coroa ];
      platforms = stdenv.lib.platforms.unix;
    };
  }
