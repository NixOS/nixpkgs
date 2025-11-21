{
  version,
  lib,
  writeText,
}:

{
  inherit version;

  mkBsdArch =
    stdenv':
    {
      x86_64 = "amd64";
      aarch64 = "aarch64";
      i486 = "i386";
      i586 = "i386";
      i686 = "i386";
      armv6l = "armv6";
      armv7l = "armv7";
      powerpc = "powerpc";
      powerpc64 = "powerpc64";
      powerpc64le = "powerpc64le";
      riscv64 = "riscv64";
    }
    .${stdenv'.hostPlatform.parsed.cpu.name} or stdenv'.hostPlatform.parsed.cpu.name;

  mkBsdCpuArch =
    stdenv':
    {
      x86_64 = "amd64";
      aarch64 = "aarch64";
      i486 = "i386";
      i586 = "i386";
      i686 = "i386";
      armv6l = "arm";
      armv7l = "arm";
      powerpc = "powerpc";
      powerpc64 = "powerpc";
      powerpc64le = "powerpc";
      riscv64 = "riscv";
    }
    .${stdenv'.hostPlatform.parsed.cpu.name} or stdenv'.hostPlatform.parsed.cpu.name;

  mkBsdMachine =
    stdenv':
    {
      x86_64 = "amd64";
      aarch64 = "arm64";
      i486 = "i386";
      i586 = "i386";
      i686 = "i386";
      armv6l = "arm";
      armv7l = "arm";
      powerpc = "powerpc";
      powerpc64 = "powerpc";
      powerpc64le = "powerpc";
      riscv64 = "riscv";
    }
    .${stdenv'.hostPlatform.parsed.cpu.name} or stdenv'.hostPlatform.parsed.cpu.name;

  install-wrapper = builtins.readFile ../../lib/install-wrapper.sh;

  # this function takes a list of patches and a list of paths and returns a list of derivations,
  # one per file that is patched, containing the actual patch contents. This allows us to have
  # extract only the patches that are relevant for a given subset of the source tree.
  # note: the "list of patches" input can be a directory containing patch files, a path or a list of valid inputs to this argument, recursively.
  filterPatches =
    patches: paths:
    let
      isDir =
        file:
        let
          base = baseNameOf file;
          type = (builtins.readDir (dirOf file)).${base} or null;
        in
        file == /. || type == "directory";
      consolidatePatches =
        patches:
        if (lib.isDerivation patches) then
          [ patches ]
        else if (builtins.isPath patches) then
          (if (isDir patches) then (lib.filesystem.listFilesRecursive patches) else [ patches ])
        else if (builtins.isList patches) then
          (lib.flatten (map consolidatePatches patches))
        else
          throw "Bad patches - must be path or derivation or list thereof";
      consolidated = consolidatePatches patches;
      splitPatch =
        patchFile:
        let
          allLines' = lib.strings.splitString "\n" (builtins.readFile patchFile);
          allLines = builtins.filter (
            line: !((lib.strings.hasPrefix "diff --git" line) || (lib.strings.hasPrefix "index " line))
          ) allLines';
          foldFunc =
            a: b:
            if ((lib.strings.hasPrefix "--- " b) || (lib.strings.hasPrefix "diff --git " b)) then
              (a ++ [ [ b ] ])
            else
              ((lib.lists.init a) ++ (lib.lists.singleton ((lib.lists.last a) ++ [ b ])));
          partitionedPatches' = lib.lists.foldl foldFunc [ [ ] ] allLines;
          partitionedPatches =
            if (builtins.length partitionedPatches' > 1) then
              (lib.lists.drop 1 partitionedPatches')
            else
              (throw "${patchFile} does not seem to be a unified patch (diff -u). this is required for FreeBSD.");
          filterFunc =
            patchLines:
            let
              prefixedPath = builtins.elemAt (builtins.split " |\t" (builtins.elemAt patchLines 1)) 2;
              unfixedPath = lib.path.subpath.join (lib.lists.drop 1 (lib.path.subpath.components prefixedPath));
            in
            lib.lists.any (
              included: lib.path.hasPrefix (/. + ("/" + included)) (/. + ("/" + unfixedPath))
            ) paths;
          filteredLines = builtins.filter filterFunc partitionedPatches;
          derive = patchLines: writeText "freebsd-patch" (lib.concatLines patchLines);
          derivedPatches = map derive filteredLines;
        in
        derivedPatches;
    in
    lib.lists.concatMap splitPatch consolidated;
}
