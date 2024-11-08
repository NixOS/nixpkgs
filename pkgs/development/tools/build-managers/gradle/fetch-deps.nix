{ mitm-cache
, lib
, pkgs
, stdenv
, callPackage
}:

let
  getPkg = attrPath:
    lib.getAttrFromPath
      (lib.splitString "." (toString attrPath))
      pkgs;
in
# the derivation to fetch/update deps for
{ pkg ? getPkg attrPath
, pname ? null
, attrPath ? pname
# bwrap flags for the update script (this will be put in bash as-is)
# this is relevant for downstream users
, bwrapFlags ? "--ro-bind \"$PWD\" \"$PWD\""
# deps path (relative to the package directory, or absolute)
, data
# redirect stdout to stderr to allow the update script to be used with update script combinators
, silent ? true
, useBwrap ? stdenv.hostPlatform.isLinux
} @ attrs:

let
  data' = builtins.removeAttrs
    (if builtins.isPath data then lib.importJSON data
    else if builtins.isString data then lib.importJSON "${dirOf pkg.meta.position}/${data}"
    else data)
    [ "!comment" "!version" ];

  parseArtifactUrl = url: let
    extension = lib.last (lib.splitString "." url);
    splitUrl = lib.splitString "/" url;
    artifactId = builtins.elemAt splitUrl (builtins.length splitUrl - 3);
    baseVer = builtins.elemAt splitUrl (builtins.length splitUrl - 2);
    filename = builtins.elemAt splitUrl (builtins.length splitUrl - 1);
    filenameNoExt = lib.removeSuffix ".${extension}" filename;
    verCls = lib.removePrefix "${artifactId}-" filenameNoExt;
  in rec {
    inherit artifactId baseVer filename extension;
    isSnapshot = lib.hasSuffix "-SNAPSHOT" baseVer;
    version =
      if isSnapshot && !lib.hasPrefix "SNAPSHOT" verCls
      then builtins.concatStringsSep "-" (lib.take 3 (lib.splitString "-" verCls))
      else baseVer;
    classifier =
      if verCls == version then null
      else lib.removePrefix "${version}-" verCls;
    # for snapshots
    timestamp = builtins.elemAt (lib.splitString "-" version) 1;
    buildNum = builtins.elemAt (lib.splitString "-" version) 2;
  };

  parseMetadataUrl = url: let
    xmlBase = lib.removeSuffix "/maven-metadata.xml" url;
    vMeta = lib.hasSuffix "-SNAPSHOT" xmlBase;
    splitBase = lib.splitString "/" xmlBase;
  in
    if vMeta then {
      vMeta = true;
      baseVer = builtins.elemAt splitBase (builtins.length splitBase - 1);
      artifactId = builtins.elemAt splitBase (builtins.length splitBase - 2);
    } else {
      vMeta = false;
      baseVer = null;
      artifactId = builtins.elemAt splitBase (builtins.length splitBase - 1);
    };

  extractHashArtifact = afterHash: let
    nameVer = builtins.match "([^/]*)/([^/]*)(/SNAPSHOT)?(/.*)?" afterHash;
    artifactId = builtins.elemAt nameVer 0;
    version = builtins.elemAt nameVer 1;
    isSnapshot = builtins.elemAt nameVer 2 != null;
    cls = builtins.elemAt nameVer 3;
  in rec {
    inherit artifactId version isSnapshot;
    baseVer =
      if !isSnapshot then version
      else builtins.head (builtins.match "(.*)-([^-]*)-([^-]*)" version) + "-SNAPSHOT";
    classifier =
      if cls == null then null
      else lib.removePrefix "/" cls;
    clsSuf =
      if classifier == null then ""
      else "-${classifier}";
  };

  # replace base#name/ver with base/name/ver/name-ver
  decompressNameVer = prefix: let
    splitHash = lib.splitString "#" (builtins.concatStringsSep "/" prefix);
    inherit (extractHashArtifact (lib.last splitHash)) artifactId baseVer version clsSuf;
  in
    if builtins.length splitHash == 1 then builtins.head splitHash
    else builtins.concatStringsSep "/${artifactId}/${baseVer}/" (lib.init splitHash ++ [ "${artifactId}-${version}${clsSuf}" ]);

  # `visit` all elements in attrs and merge into a set
  # attrs will be passed as parent1, parent1 will be passed as parent2
  visitAttrs = parent1: prefix: attrs:
    builtins.foldl'
      (a: b: a // b)
      {}
      (lib.mapAttrsToList (visit parent1 attrs prefix) attrs);

  # convert a compressed deps.json into an uncompressed json used for mitm-cache.fetch
  visit = parent2: parent1: prefix: k: v:
    # groupId being present means this is a metadata xml "leaf" and we shouldn't descend further
    if builtins.isAttrs v && !v?groupId
    then visitAttrs parent1 (prefix ++ [k]) v
    else let
      url = "${decompressNameVer prefix}.${k}";
    in {
      ${url} =
        if builtins.isString v then { hash = v; }
        else {
          text = let
            xmlBase = lib.removeSuffix "/maven-metadata.xml" url;
            meta = parseMetadataUrl url // v;
            inherit (meta) groupId vMeta artifactId baseVer;

            fileList = builtins.filter (x: lib.hasPrefix xmlBase x && x != url) (builtins.attrNames finalData);
            jarPomList = map parseArtifactUrl fileList;

            sortByVersion = a: b: (builtins.compareVersions a.version b.version) < 0;
            sortedJarPomList = lib.sort sortByVersion jarPomList;

            uniqueVersionFiles =
              builtins.map ({ i, x }: x)
                (builtins.filter ({ i, x }: i == 0 || (builtins.elemAt sortedJarPomList (i - 1)).version != x.version)
                  (lib.imap0 (i: x: { inherit i x; }) sortedJarPomList));
            uniqueVersions' = map (x: x.version) uniqueVersionFiles;
            releaseVersions = map (x: x.version) (builtins.filter (x: !x.isSnapshot) uniqueVersionFiles);
            latestVer = v.latest or v.release or (lib.last uniqueVersions');
            releaseVer = v.release or (lib.last releaseVersions);

            # The very latest version isn't necessarily used by Gradle, so it may not be present in the MITM data.
            # In order to generate better metadata xml, if the latest version is known but wasn't fetched by Gradle,
            # add it anyway.
            uniqueVersions =
              uniqueVersions'
              ++ lib.optional (!builtins.elem releaseVer uniqueVersions') releaseVer
              ++ lib.optional (!builtins.elem latestVer uniqueVersions' && releaseVer != latestVer) latestVer;

            lastUpdated = v.lastUpdated or
              (if vMeta then builtins.replaceStrings ["."] [""] snapshotTs
              else "20240101123456");

            # the following are only used for snapshots
            snapshotTsAndNum = lib.splitString "-" latestVer;
            snapshotTs = builtins.elemAt snapshotTsAndNum 1;
            snapshotNum = lib.last snapshotTsAndNum;

            indent = x: s: builtins.concatStringsSep "\n" (map (s: x + s) (lib.splitString "\n" s));
            containsSpecialXmlChars = s: builtins.match ''.*[<>"'&].*'' s != null;
          in
            # make sure all user-provided data is safe
            assert lib.hasInfix "${builtins.replaceStrings ["."] ["/"] groupId}/${artifactId}" url;
            assert !containsSpecialXmlChars groupId;
            assert !containsSpecialXmlChars lastUpdated;
          if vMeta then ''
            <?xml version="1.0" encoding="UTF-8"?>
            <metadata modelVersion="1.1.0">
              <groupId>${groupId}</groupId>
              <artifactId>${artifactId}</artifactId>
              <version>${baseVer}</version>
              <versioning>
                <snapshot>
                  <timestamp>${snapshotTs}</timestamp>
                  <buildNumber>${snapshotNum}</buildNumber>
                </snapshot>
                <lastUpdated>${lastUpdated}</lastUpdated>
                <snapshotVersions>
            ${builtins.concatStringsSep "\n" (map (x: indent "      " ''
                  <snapshotVersion>${
                    lib.optionalString
                      (x.classifier != null)
                      "\n        <classifier>${x.classifier}</classifier>"
                  }
                    <extension>${x.extension}</extension>
                    <value>${x.version}</value>
                    <updated>${builtins.replaceStrings ["."] [""] x.timestamp}</updated>
                  </snapshotVersion>'') sortedJarPomList)}
                </snapshotVersions>
              </versioning>
            </metadata>
          ''
          else
            assert !containsSpecialXmlChars latestVer;
            assert !containsSpecialXmlChars releaseVer;
          ''
            <?xml version="1.0" encoding="UTF-8"?>
            <metadata modelVersion="1.1.0">
              <groupId>${groupId}</groupId>
              <artifactId>${artifactId}</artifactId>
              <versioning>
                <latest>${latestVer}</latest>
                <release>${releaseVer}</release>
                <versions>
            ${builtins.concatStringsSep "\n" (map (x: "      <version>${x}</version>") uniqueVersions)}
                </versions>
                <lastUpdated>${lastUpdated}</lastUpdated>
              </versioning>
            </metadata>
          '';
        };
    };

  finalData = visitAttrs {} [] data';
in
  mitm-cache.fetch {
    name = "${pkg.pname or pkg.name}-deps";
    data = finalData // { "!version" = 1; };
    passthru = lib.optionalAttrs (!builtins.isAttrs data) {
      updateScript = callPackage ./update-deps.nix { } {
        inherit pkg pname attrPath bwrapFlags data silent useBwrap;
      };
    };
  }
