{ stdenv
, lib
, google-cloud-sdk
, system
, snapshotPath
, autoPatchelfHook
, python3
, libxcrypt-legacy
, ...
}:

let
  # Mapping from GCS component architecture names to Nix archictecture names
  arches = {
    x86 = "i686";
    x86_64 = "x86_64";
    arm = "aarch64";
  };

  # Mapping from GCS component operating systems to Nix operating systems
  oses = {
    LINUX = "linux";
    MACOSX = "darwin";
    WINDOWS = "windows";
    CYGWIN = "cygwin";
  };

  # Convert an archicecture + OS to a Nix platform
  toNixPlatform = arch: os:
    let
      arch' = arches.${arch} or (throw "unsupported architecture '${arch}'");
      os' = oses.${os} or (throw "unsupported OS '${os}'");
    in
    "${arch'}-${os'}";

  # All architectures that are supported by GCS
  allArches = builtins.attrNames arches;

  # A description of all available google-cloud-sdk components.
  # It's a JSON file with a list of components, along with some metadata
  snapshot = builtins.fromJSON (builtins.readFile snapshotPath);

  # Generate a snapshot file for a single component.  It has the same format as
  # `snapshot`, but only contains a single component.  These files are
  # installed with google-cloud-sdk to let it know which components are
  # available.
  snapshotFromComponent =
    { component
    , revision
    , schema_version
    , version
    }:
    builtins.toJSON {
      components = [ component ];
      inherit revision schema_version version;
    };

  # Generate a set of components from a JSON file describing these components
  componentsFromSnapshot =
    { components
    , revision
    , schema_version
    , version
    , ...
    }:
    lib.fix (
      self:
      builtins.listToAttrs (
        builtins.map
          (component: {
            name = component.id;
            value = componentFromSnapshot self { inherit component revision schema_version version; };
          })
          components
      )
    );

  # Generate a single component from its snapshot, along with a set of
  # available dependencies to choose from.
  componentFromSnapshot =
    # Component derivations that can be used as dependencies
    components:
    # This component's snapshot
    { component
    , revision
    , schema_version
    , version
    } @ attrs:
    let
      baseUrl = builtins.dirOf schema_version.url;
      # Architectures supported by this component.  Defaults to all available
      # architectures.
      architectures = builtins.filter
        (arch: builtins.elem arch (builtins.attrNames arches))
        (lib.attrByPath [ "platform" "architectures" ] allArches component);
      # Operating systems supported by this component
      operating_systems = builtins.filter
        (os: builtins.elem os (builtins.attrNames oses))
        component.platform.operating_systems;
    in
    mkComponent
      {
        pname = component.id;
        version = component.version.version_string;
        src =
          lib.optionalString (lib.hasAttrByPath [ "data" "source" ] component) "${baseUrl}/${component.data.source}";
        sha256 = lib.attrByPath [ "data" "checksum" ] "" component;
        dependencies = builtins.map (dep: builtins.getAttr dep components) component.dependencies;
        platforms =
          if component.platform == { }
          then lib.platforms.all
          else
            builtins.concatMap
              (arch: builtins.map (os: toNixPlatform arch os) operating_systems)
              architectures;
        snapshot = snapshotFromComponent attrs;
      };

  # Filter out dependencies not supported by current system
  filterForSystem = builtins.filter (drv: builtins.elem system drv.meta.platforms);

  # Make a google-cloud-sdk component
  mkComponent =
    { pname
    , version
      # Source tarball, if any
    , src ? ""
      # Checksum for the source tarball, if there is a source
    , sha256 ? ""
      # Other components this one depends on
    , dependencies ? [ ]
      # Short text describing the component
    , description ? ""
      # Platforms supported
    , platforms ? lib.platforms.all
      # The snapshot corresponding to this component
    , snapshot
    }: stdenv.mkDerivation {
      inherit pname version snapshot;
      src =
        lib.optionalString (src != "")
          (builtins.fetchurl
            {
              url = src;
              inherit sha256;
            }) ;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/google-cloud-sdk/.install

        # If there is a source, unpack it
        if [ ! -z "$src" ]; then
          tar -xf $src -C $out/google-cloud-sdk/

          # If the source has binaries, link them to `$out/bin`
          if [ -d "$out/google-cloud-sdk/bin" ]; then
            mkdir $out/bin
            find $out/google-cloud-sdk/bin/ -type f -exec ln -s {} $out/bin/ \;
          fi
        fi

        # Write the snapshot file to the `.install` folder
        cp $snapshotPath $out/google-cloud-sdk/.install/${pname}.snapshot.json
      '';
      nativeBuildInputs = [
        python3
        stdenv.cc.cc
      ] ++ lib.optionals stdenv.isLinux [
        autoPatchelfHook
      ];
      buildInputs = [
        libxcrypt-legacy
      ];
      passthru = {
        dependencies = filterForSystem dependencies;
      };
      passAsFile = [ "snapshot" ];
      meta = {
        inherit description platforms;
      };
    };
in
componentsFromSnapshot snapshot
