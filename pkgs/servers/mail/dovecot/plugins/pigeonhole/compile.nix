{dovecot_pigeonhole, lib, writeText }:
{ name, plugins ? [], extensions ? [], globalExtensions ? [], meta ? {}, nativeBuildInputs ? [], ... } @ args:
with lib;
let
  config = writeText "buildSieveScripts-${name}-config" ''
    plugin {
      ${optionalString (plugins != [])
        "sieve_plugins = ${concatStringsSep " " (map (e: "sieve_${e}") plugins)}"}
      ${optionalString (extensions != [])
        "sieve_extensions = ${concatStringsSep " " extensions}"}
      ${optionalString (globalExtensions != [])
        "sieve_global_extensions = ${concatStringsSep " " globalExtensions}"}
    }
  '';
in

dovecot_pigeonhole.stdenv.mkDerivation (args // {
  inherit name;
  nativeBuildInputs = nativeBuildInputs ++ [ dovecot_pigeonhole ];
  installPhase = ''
    mkdir -p "$out/sieve/"
    for k in $(find * -name \*.sieve); do
      mkdir -p "$out/sieve/$(dirname "$k")"
      cp -a "$k" "$out/sieve/$k"
      if [[ ! -L "$k" ]]; then
        echo "Compiling $k"
        touch -m --date=@0 "$out/sieve/$k"
      else
        echo "Compiling $k -> $(readlink -f "$k")"
      fi
      sievec -c "${config}" "$out/sieve/$k"
    done
  '' + (args.installPhase or "");

  meta = {
    platforms = dovecot_pigeonhole.meta.platforms or lib.platforms.all;
  } // meta;
})
