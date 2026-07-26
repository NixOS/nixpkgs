{
  lib,
  config,
  buildPlatform,
  callPackage,
  kaem,
  mescc-tools-extra,
  checkMeta,
  hostPlatform,
}:
let
  assertValidity = checkMeta.assertValidity hostPlatform;
  commonMeta = checkMeta.commonMeta hostPlatform;
in
rec {
  maybeContentAddressed = lib.optionalAttrs config.contentAddressedByDefault {
    __contentAddressed = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  derivationWithMeta =
    let
      removedAttributeNames = [
        "meta"
        "passthru"
      ];
    in
    attrs:
    let
      passthru = attrs.passthru or { };
      validity = assertValidity { inherit meta attrs; };
      meta = commonMeta { inherit validity attrs; };
      baseDrv = derivation (
        {
          inherit (buildPlatform) system;
          # redefining from meta to avoid forcing the thunk until it's used
          name = attrs.name or "${attrs.pname}-${attrs.version}";
        }
        // maybeContentAddressed
        // (removeAttrs attrs removedAttributeNames)
      );
      passthru' =
        if passthru ? tests then
          passthru
          // {
            tests = lib.mapAttrs (_: f: f baseDrv) passthru.tests;
          }
        else
          passthru;
    in
    lib.extendDerivation validity.handled (
      {
        inherit meta;
        passthru = passthru';
      }
      // passthru'
    ) baseDrv;

  writeTextFile =
    let
      PATH = lib.makeBinPath [ mescc-tools-extra ];
    in
    {
      name, # the name of the derivation
      text,
      executable ? false, # run chmod +x ?
      destination ? "", # relative path appended to $out eg "/bin/foo"
    }:
    derivationWithMeta {
      inherit name text;
      passAsFile = [ "text" ];

      builder = "${kaem}/bin/kaem";
      args = [
        "--verbose"
        "--strict"
        "--file"
        (builtins.toFile "write-text-file.kaem" (
          ''
            target=''${out}''${destination}
          ''
          + lib.optionalString (destination == "") ''
            mkdir -p ''${out}''${destinationDir}
          ''
          + ''
            cp ''${textPath} ''${target}
          ''
          + lib.optionalString executable ''
            chmod 555 ''${target}
          ''
        ))
      ];

      inherit PATH;
      destinationDir = dirOf destination;
      inherit destination;
    };

  writeText = name: text: writeTextFile { inherit name text; };

}
