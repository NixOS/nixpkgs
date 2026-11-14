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
      baseDrvAttrs = {
        inherit (buildPlatform) system;
        # redefining from meta to avoid forcing the thunk until it's used
        name = attrs.name or "${attrs.pname}-${attrs.version}";
      }
      // maybeContentAddressed
      // (removeAttrs attrs removedAttributeNames);
      passthru' =
        if passthru ? tests then
          passthru
          // {
            tests = lib.mapAttrs (_: f: f final) passthru.tests;
          }
        else
          passthru;
      final = lib.checkedDerivation validity.handled (
        {
          inherit meta;
          passthru = passthru';
        }
        // passthru'
      ) baseDrvAttrs;
    in
    final;

  writeTextFile =
    let
      PATH = lib.makeBinPath [ mescc-tools-extra ];
      builders = builtins.mapAttrs (_: builtins.toFile "write-text-file.kaem") {
        emptyDestinationExecutable = ''
          target=''${out}''${destination}
          mkdir -p ''${out}''${destinationDir}
          cp ''${textPath} ''${target}
          chmod 555 ''${target}
        '';
        emptyDestinationNonExecutable = ''
          target=''${out}''${destination}
          mkdir -p ''${out}''${destinationDir}
          cp ''${textPath} ''${target}
        '';
        nonEmptyDestinationExecutable = ''
          target=''${out}''${destination}
          cp ''${textPath} ''${target}
          chmod 555 ''${target}
        '';
        nonEmptyDestinationNonExecutable = ''
          target=''${out}''${destination}
          cp ''${textPath} ''${target}
        '';
      };
      getWriteTextFileBuilder =
        destinationEmpty: executable:
        if destinationEmpty then
          if executable then builders.emptyDestinationExecutable else builders.emptyDestinationNonExecutable
        else if executable then
          builders.nonEmptyDestinationExecutable
        else
          builders.nonEmptyDestinationNonExecutable;
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
        (getWriteTextFileBuilder (destination == "") executable)
      ];

      inherit PATH;
      destinationDir = dirOf destination;
      inherit destination;
    };

  writeText = name: text: writeTextFile { inherit name text; };

}
