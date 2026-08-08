{
  lib,
  writeText,
}:

let
  minimalPom =
    {
      groupId,
      artifactId,
      version,
    }:
    ''
      <?xml version="1.0" encoding="UTF-8"?>
      <project>
        <modelVersion>4.0.0</modelVersion>
        <groupId>${groupId}</groupId>
        <artifactId>${artifactId}</artifactId>
        <version>${version}</version>
        <packaging>jar</packaging>
      </project>
    '';

  # Shared builder: produce a single GAV override entry given resolved inputs.
  mkEntry =
    {
      groupId,
      artifactId,
      version,
      jarSource,
      pom ? null,
    }:
    let
      base = "${artifactId}-${version}";
      pomDrv = writeText "${base}.pom" (
        if pom != null then pom else minimalPom { inherit groupId artifactId version; }
      );
    in
    {
      "${groupId}:${artifactId}:${version}" = {
        "${base}.jar" = _: jarSource;
        "${base}.pom" = _: pomDrv;
      };
    };

  mkArtifactEntry =
    {
      # nixpkgs derivation providing the JAR.
      drv,
      groupId,
      artifactId,
      version,
      # Subpath within drv to the JAR file (e.g. "share/java/foo-1.0.jar").
      # If null, drv itself is treated as the JAR (only correct when drv is a
      # single-file fetchurl result).
      jarPath ? null,
      # Full POM XML string. If null a minimal four-field POM is generated,
      # which is sufficient for Gradle's offline resolver.
      pom ? null,
    }:
    mkEntry {
      inherit
        groupId
        artifactId
        version
        pom
        ;
      jarSource = if jarPath != null then "${drv}/${jarPath}" else "${drv}";
    };

in
{
  # Build an overrides attrset from a list of nixpkgs-backed artifact specs.
  # Each spec is an attrset with: drv, groupId, artifactId, version, jarPath?, pom?
  mkGradleLocalOverrides = artifacts: lib.mergeAttrsList (map mkArtifactEntry artifacts);

  # Build override entries that transparently redirect requests for old
  # (potentially vulnerable) artifact versions to a safe replacement.
  # The MITM proxy will serve `jar` whenever Gradle requests any of the
  # `oldVersions`, without any changes to the package's deps.json.
  #
  # Example:
  #   gradle.mkVersionChainUpgrade {
  #     groupId    = "commons-codec";
  #     artifactId = "commons-codec";
  #     oldVersions = [ "1.0" "1.1" "1.2" "1.3" "1.4" "1.5" "1.6"
  #                     "1.7" "1.8" "1.9" "1.10" "1.11" "1.12" ];
  #     jar = fetchurl {
  #       url  = "https://repo.maven.apache.org/maven2/commons-codec/commons-codec/1.13/commons-codec-1.13.jar";
  #       hash = "sha256-...";
  #     };
  #   }
  mkVersionChainUpgrade =
    {
      groupId,
      artifactId,
      oldVersions,
      # Derivation or store path of the replacement JAR.
      jar,
      # Optional full POM XML for the replacement. If null a minimal POM is
      # generated bearing the *old* version coordinate so Gradle's resolver
      # does not notice the substitution.
      pom ? null,
    }:
    lib.mergeAttrsList (
      map (
        oldVer:
        mkEntry {
          inherit groupId artifactId pom;
          version = oldVer;
          jarSource = jar;
        }
      ) oldVersions
    );
}
