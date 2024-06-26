{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  modelSpecs = (builtins.fromJSON (builtins.readFile ./models.json));
  withCodeAsKey = f: { code, ... }@attrs: lib.nameValuePair code (f attrs);
  mkModelPackage =
    {
      name,
      code,
      version,
      url,
      checksum,
    }:
    stdenvNoCC.mkDerivation {
      pname = "translatelocally-model-${code}";
      version = toString version;

      src = fetchurl {
        inherit url;
        sha256 = checksum;
      };
      dontUnpack = true;

      installPhase = ''
        TARGET="$out/share/translateLocally/models"
        mkdir -p "$TARGET"
        tar -xzf "$src" -C "$TARGET"

        # avoid patching shebangs in inconsistently executable extra files
        find "$out" -type f -exec chmod -x {} +
      '';

      meta = {
        description = "translateLocally model - ${name}";
        homepage = "https://translatelocally.com/";
        # https://github.com/browsermt/students/blob/master/LICENSE.md
        license = lib.licenses.cc-by-sa-40;
      };
    };
  allModelPkgs = lib.listToAttrs (map (withCodeAsKey mkModelPackage) modelSpecs);

in
allModelPkgs
// {
  is-en-tiny = allModelPkgs.is-en-tiny.overrideAttrs (super: {
    # missing model https://github.com/XapaJIaMnu/translateLocally/issues/147
    meta = super.meta // {
      broken = true;
    };
  });
}
// {
  passthru.updateScript = ./update.sh;
}
