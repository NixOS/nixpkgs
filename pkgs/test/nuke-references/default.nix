{
  lib,
  nukeReferences,
  runCommand,
}:

let
  hash1 = lib.strings.replicate 32 "a";
  hash2 = lib.strings.replicate 32 "b";
  hash3 = lib.strings.replicate 32 "c";
  fakeHash = lib.strings.replicate 32 "e";

  mkTest =
    {
      name,
      input,
      expected,
      extraNukeRefsArgs ? [ ],
    }:
    runCommand "nuke-refs-test-${name}" { } ''
      printf -- ${lib.escapeShellArg input} > input
      printf -- ${lib.escapeShellArg expected} > expected

      cp input actual
      ${lib.getExe nukeReferences} ${lib.escapeShellArgs extraNukeRefsArgs} actual

      if ! cmp -s actual expected; then
        echo "nuke-refs test '${name}' failed: output did not match expectation"
        echo "--- input ---"; od -c input
        echo "--- expected ---"; od -c expected
        echo "--- actual ---"; od -c actual
        exit 1
      fi

      touch $out
    '';
in
{
  storeDirPrefixWithoutValidHash =
    let
      content = ''
        ${builtins.storeDir}/short-name
        ${builtins.storeDir}/ABCDEFGHIJKLMNOPQRSTUVWXYZ012345-name
        ${builtins.storeDir}/${hash1}NODASH
        ${builtins.storeDir}/
      '';
    in
    mkTest {
      name = "storedir-prefix-without-valid-hash";
      input = content;
      expected = content;
    };

  hashWithoutStoreDirPrefix =
    let
      content = ''
        ${hash1}-name.so
        /some/other/dir/${hash1}-name.so
      '';
    in
    mkTest {
      name = "hash-without-storedir-prefix";
      input = content;
      expected = content;
    };

  bytes = mkTest {
    name = "bytes";
    # `\x..` will be interpreted by `printf`
    input = "\\x7fELF\\x00\\x00\\x00\\x00${builtins.storeDir}/${hash1}-foo.so\\x00\\x00\\x00some\\x00embedded\\x00nulls\\x00here${builtins.storeDir}/${hash2}-bar.so\\x00";
    expected = "\\x7fELF\\x00\\x00\\x00\\x00${builtins.storeDir}/${fakeHash}-foo.so\\x00\\x00\\x00some\\x00embedded\\x00nulls\\x00here${builtins.storeDir}/${fakeHash}-bar.so\\x00";
  };

  excludeOnBytes = mkTest {
    name = "exclude-on-bytes";
    input = "\\x7fELF\\x00\\x00\\x00\\x00${builtins.storeDir}/${hash1}-foo.so\\x00\\x00\\x00some\\x00embedded\\x00nulls\\x00here${builtins.storeDir}/${hash2}-bar.so\\x00";
    expected = "\\x7fELF\\x00\\x00\\x00\\x00${builtins.storeDir}/${hash1}-foo.so\\x00\\x00\\x00some\\x00embedded\\x00nulls\\x00here${builtins.storeDir}/${fakeHash}-bar.so\\x00";
    extraNukeRefsArgs = [
      "-e"
      "${builtins.storeDir}/${hash1}-foo.so"
    ];
  };

  # This verifies that the regex built by multiple `-e` arguments works correctly
  excludeTwoOnBytes = mkTest {
    name = "exclude-two-on-bytes";
    input = "\\x7fELF\\x00\\x00\\x00\\x00${builtins.storeDir}/${hash1}-a.so\\x00${builtins.storeDir}/${hash2}-b.so\\x00${builtins.storeDir}/${hash3}-c.so\\x00";
    expected = "\\x7fELF\\x00\\x00\\x00\\x00${builtins.storeDir}/${hash1}-a.so\\x00${builtins.storeDir}/${fakeHash}-b.so\\x00${builtins.storeDir}/${hash3}-c.so\\x00";
    extraNukeRefsArgs = [
      "-e"
      "${builtins.storeDir}/${hash1}-a.so"
      "-e"
      "${builtins.storeDir}/${hash3}-c.so"
    ];
  };
}
