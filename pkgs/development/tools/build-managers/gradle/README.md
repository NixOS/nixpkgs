# Gradle Setup Hook

## Introduction

Gradle build scripts are written in a DSL, computing the list of Gradle
dependencies is a Turing-complete task, not just in theory but also in
practice. Fetching all of the dependencies often requires building some
native code, running some commands to check the host platform, or just
fetching some files using either JVM code or commands like `curl` or
`wget`.

This practice is widespread and isn't considered a bad practice in the
Java world, so all we can do is run Gradle to check what dependencies
end up being fetched, and allow derivation authors to apply workarounds
so they can run the code necessary for fetching the dependencies our
script doesn't fetch.

"Run Gradle to check what dependencies end up being fetched" isn't a
straightforward task. For example, Gradle usually uses Maven
repositories, which have features such as "snapshots", a way to always
use the latest version of a dependency as opposed to a fixed version.
Obviously, this is horrible for reproducibility. Additionally, Gradle
doesn't offer a way to export the list of dependency URLs and hashes (it
does in a way, but it's far from being complete, and as such is useless
for Nixpkgs). Even if it did, it would be annoying to use considering
fetching non-Gradle dependencies in Gradle scripts is commonplace.

That's why the setup hook uses mitm-cache, a program designed for
intercepting all HTTP requests, recording all the files that were
accessed, creating a Nix derivation with all of them, and then allowing
the Gradle derivation to access these files.

## Maven Repositories

(Reference: [Repository
Layout](https://cwiki.apache.org/confluence/display/MAVENOLD/Repository+Layout+-+Final))

Most of Gradle dependencies are fetched from Maven repositories. For
each dependency, Gradle finds the first repo where it can successfully
fetch that dependency, and uses that repo for it. Different repos might
actually return different files for the same artifact because of e.g.
pom normalization. Different repos may be used for the same artifact
even across a single package (for example, if two build scripts define
repositories in a different order).

The artifact metadata is specified in a .pom file, and the artifacts
themselves are typically .jar files. The URL format is as follows:

`<repo>/<group-id>/<artifact-id>/<base-version>/<artifact-id>-<version>[-<classifier>].<ext>`

For example:

- `https://repo.maven.apache.org/maven2/org/slf4j/slf4j-api/2.0.9/slf4j-api-2.0.9.pom`
- `https://oss.sonatype.org/content/groups/public/com/tobiasdiez/easybind/2.2.1-SNAPSHOT/easybind-2.2.1-20230117.075740-16.pom`

Where:

- `<repo>` is the repo base (`https://repo.maven.apache.org/maven2`)
- `<group-id>` is the group ID with dots replaced with slashes
  (`org.slf4j` -> `org/slf4j`)
- `<artifact-id>` is the artifact ID (`slf4j-api`)
- `<base-version>` is the artifact version (`2.0.9` for normal
  artifacts, `2.2.1-SNAPSHOT` for snapshots)
- `<version>` is the artifact version - can be either `<base-version>`
  or `<version-base>-<timestamp>-<build-num>` (`2.0.9` for normal
  artifacts, and either `2.2.1-SNAPSHOT` or `2.2.1-20230117.075740-16`
  for snapshots)
  - `<version-base>` - `<base-version>` without the `-SNAPSHOT` suffix
  - `<timestamp>` - artifact build timestamp in the `YYYYMMDD.HHMMSS`
    format (UTC)
  - `<build-num>` - a counter that's incremented by 1 for each new
    snapshot build
- `<classifier>` is an optional classifier for allowing a single .pom to
  refer to multiple .jar files. .pom files don't have classifiers, as
  they describe metadata.
- `<ext>` is the extension. .pom

Note that the artifact ID can contain `-`, so you can't extract the
artifact ID and version from just the file name.

Additionally, the files in the repository may have associated signature
files, formed by appending `.asc` to the filename, and hashsum files,
formed by appending `.md5` or `.sha1` to the filename. The signatures
are harmless, but the `.md5`/`.sha1` files are rejected.

The reasoning is as follows - consider two files `a.jar` and `b.jar`,
that have the same hash. Gradle will fetch `a.jar.sha1`, find out that
it hasn't yet downloaded a file with this hash, and then fetch `a.jar`,
and finally download `b.jar.sha1`, locate it in its cache, and then
*not* download `b.jar`. This means `b.jar` won't be stored in the MITM
cache. Then, consider that on a later invocation, the fetching order
changed, whether it was because of running on a different system,
changed behavior after a Gradle update, or any other source of
nondeterminism - `b.jar` is fetched before `a.jar`. Gradle will first
fetch `b.jar.sha1`, not find it in its cache, attempt to fetch `b.jar`,
and fail, as the cache doesn't have that file.

For the same reason, the proxy strips all checksum/etag headers. An
alternative would be to make the proxy remember previous checksums and
etags, but that would complicate the implementation - however, such a
feature can be implemented if necessary. Note that checksum/etag header
stripping is hardcoded, but `.md5/.sha1` file rejection is configured
via CLI arguments.

**Caveat**: Gradle .module files also contain file hashes, in md5, sha1,
sha256, sha512 formats. It has posed no problem as of yet, but it might in
the future. If it does pose problems, the deps derivation code can be
extended to find all checksums in .module files and copy existing files
there if their hash matches.

## Snapshots

Snapshots are a way to publish the very latest, unstable version of a
dependency that constantly changes. Any project that depends on a
snapshot will depend on this rolling version, rather than a fixed
version. It's easy to understand why this is a bad idea for reproducible
builds. Still, they can be dealt with by the logic in `gradle.fetchDeps`
and `gradle.updateDeps`.

First, as you can see above, while normal artifacts have the same
`base-version` and `version`, for snapshots it usually (but not
necessarily) differs.

Second, for figuring out where to download the snapshot, Gradle consults
`maven-metadata.xml`. With that in mind...

## Maven Metadata

(Reference: [Maven
Metadata](https://maven.apache.org/repositories/metadata.html),
[Metadata](https://maven.apache.org/ref/3.9.8/maven-repository-metadata/repository-metadata.html)

Maven metadata files are called `maven-metadata.xml`.

There are three levels of metadata: "G level", "A level", "V level",
representing group, artifact, or version metadata.

G level metadata is currently unsupported. It's only used for Maven
plugins, which Gradle presumably doesn't use.

A level metadata is used for getting the version list for an artifact.
It's an xml with the following items:

- `<groupId>` - group ID
- `<artifactId>` - artifact ID
- `<versioning>`
  - `<latest>` - the very latest base version (e.g. `2.2.1-SNAPSHOT`)
  - `<release>` - the latest non-snapshot version
  - `<versions>` - the version list, each in a `<version>` tag
  - `<lastUpdated>` - the metadata update timestamp (UTC,
    `YYYYMMDDHHMMSS`)

V level metadata is used for listing the snapshot versions. It has the
following items:

- `<groupId>` - group ID
- `<artifactId>` - artifact ID
- `<versioning>`
  - `<lastUpdated>` - the metadata update timestamp (UTC,
    `YYYYMMDDHHMMSS`)
  - `<snapshot>` - info about the latest snapshot version
    - `<timestamp>` - build timestamp (UTC, `YYYYMMDD.HHMMSS`)
    - `<buildNumber>` - build number
  - `<snapshotVersions>` - the list of all available snapshot file info,
    each info is enclosed in a `<snapshotVersion>`
    - `<classifier>` - classifier (optional)
    - `<extension>` - file extension
    - `<value>` - snapshot version (as opposed to base version)
    - `<updated>` - snapshot build timestamp (UTC, `YYYYMMDDHHMMSS`)

## Lockfile Format

The mitm-cache lockfile format is described in the [mitm-cache
README](https://github.com/chayleaf/mitm-cache#readme).

The Nixpkgs Gradle lockfile format is more complicated:

```json
{
  "!comment": "This is a Nixpkgs Gradle dependency lockfile. For more details, refer to the Gradle section in the Nixpkgs manual.",
  "!version": 1,
  "https://oss.sonatype.org/content/repositories/snapshots/com/badlogicgames/gdx-controllers": {
    "gdx-controllers#gdx-controllers-core/2.2.4-20231021.200112-6/SNAPSHOT": {

      "jar": "sha256-Gdz2J1IvDJFktUD2XeGNS0SIrOyym19X/+dCbbbe3/U=",
      "pom": "sha256-90QW/Mtz1jbDUhKjdJ88ekhulZR2a7eCaEJoswmeny4="
    },
    "gdx-controllers-core/2.2.4-SNAPSHOT/maven-metadata": {
      "xml": {
        "groupId": "com.badlogicgames.gdx-controllers"
      }
    }
  },
  "https://repo.maven.apache.org/maven2": {
    "com/badlogicgames/gdx#gdx-backend-lwjgl3/1.12.1": {
      "jar": "sha256-B3OwjHfBoHcJPFlyy4u2WJuRe4ZF/+tKh7gKsDg41o0=",
      "module": "sha256-9O7d2ip5+E6OiwN47WWxC8XqSX/mT+b0iDioCRTTyqc=",
      "pom": "sha256-IRSihaCUPC2d0QzB0MVDoOWM1DXjcisTYtnaaxR9SRo="
    }
  }
}
```

`!comment` is a human-readable description explaining what the file is,
`!version` is the lockfile version (note that while it shares the name
with mitm-cache's `!version`, they don't actually have to be in sync and
can be bumped separately).

The other keys are parts of a URL. Each URL is split into three parts.
They are joined like this: `<part1>/<part2>.<part3>`.

Some URLs may have a `#` in them. In that case, the part after `#` is
parsed as `#<artifact-id>/<version>[/SNAPSHOT][/<classifier>].<ext>` and
expanded into
`<artifact-id>/<base-version>/<artifact-id>-<version>[-<classifier>].<ext>`.

Each URL has a value associated with it. The value may be:

- an SRI hash (string)
- for `maven-metadata.xml` - an attrset containing the parts of the
  metadata that can't be generated in Nix code (e.g. `groupId`, which is
  challenging to parse from a URL because it's not always possible to
  discern where the repo base ends and the group ID begins).

`compress-deps-json.py` converts the JSON from mitm-cache format into
Nixpkgs Gradle lockfile format. `fetch.nix` does the opposite.

## Security Considerations

Lockfiles won't be human-reviewed. They must be tampering-resistant.
That's why it's imperative that nobody can inject their own contents
into the lockfiles.

This is achieved in a very simple way - the `deps.json` only contains
the following:

- `maven-metadata.xml` URLs and small pieces of the contained metadata
  (most of it will be generated in Nix, i.e. the area of injection is
  minimal, and the parts that aren't generated in Nix are validated).
- artifact/other file URLs and associated hashes (Nix will complain if
  the hash doesn't match, and Gradle won't even access the URL if it
  doesn't match)

Please be mindful of the above when working on Gradle support for
Nixpkgs.
