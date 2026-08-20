{
  lib,
  stdenv,
  fetchurl,
  jre,
  writeShellApplication,
  common-updater-scripts,
  coreutils,
  git,
  gnugrep,
  gnused,
  jq,
  nix,
}:

let
  owner = "com-lihaoyi";
  repo = "Ammonite";

  # One table for every variant, so the update script cannot refresh some and
  # miss others; it used to skip ammonite_3_3, which is what `ammonite` is.
  variants = {
    ammonite_2_12 = {
      scalaVersion = "2.12";
      hash = "sha256-gMyTQDPmHsl6b3CBCsIHb/8z2FwL3+Txuz0siFgvSws=";
    };
    ammonite_2_13 = {
      scalaVersion = "2.13";
      hash = "sha256-NCB5ZuW+CqxFlYY10mF6TUHdZl1E8QFygPdyW2FtCe4=";
    };
    ammonite_3_3 = {
      scalaVersion = "3.3";
      hash = "sha256-H3/wjBDA8b+a+4FISohLQ10eB7VOMUqj+M39bZOefbw=";
    };
  };

  common =
    { scalaVersion, hash }:
    stdenv.mkDerivation rec {
      pname = "ammonite";
      version = "3.0.9";

      src = fetchurl {
        url = "https://github.com/${owner}/${repo}/releases/download/${version}/${scalaVersion}-${version}";
        inherit hash;
      };

      dontUnpack = true;

      # ammonite.AmmoniteMain is class-file 55, so an older jre fails the install
      # check below with UnsupportedClassVersionError rather than anything useful
      installPhase =
        assert lib.assertMsg (lib.versionAtLeast jre.version "11.0.0") ''
          ammonite requires Java 11 or newer, but ${jre.name} is ${jre.version}
        '';
        ''
          install -Dm755 $src $out/bin/amm

          # Upstream ships a .bat/.sh polyglot with no interpreter directive, so
          # without this execve gives ENOEXEC to every caller that does not retry
          # under /bin/sh the way a shell does. patchShebangs pins it afterwards.
          sed -i '1i #!/bin/sh' $out/bin/amm

          # The launcher prefers $JAVA_HOME over its own default, so both branches
          # have to be pinned; patching only the default leaves `override { jre = ...; }`
          # with no effect in any shell that sets JAVA_HOME. sed rather than
          # substituteInPlace because the launcher has a jar appended to it.
          sed -i \
            -e 's|JAVACMD="java"|JAVACMD="${jre}/bin/java"|' \
            -e 's|JAVACMD="$JAVA_HOME/bin/java"|JAVACMD="${jre}/bin/java"|' \
            $out/bin/amm

          # sed is silent when it matches nothing, which is how the JAVA_HOME
          # branch went unpatched in the first place.
          if grep -qa 'JAVACMD="$JAVA_HOME/bin/java"' $out/bin/amm; then
            echo "the amm launcher still prefers JAVA_HOME; the substitution missed" >&2
            exit 1
          fi

          # Hand the same jre to whatever the repl spawns. makeWrapper is not an
          # option here: the launcher passes itself as the classpath with -cp "$0",
          # so a wrapper that changes $0 breaks it.
          sed -i "/^exec /i export JAVA_HOME=\"${jre.home}\"\nexport PATH=\"${lib.makeBinPath [ jre ]}\''${PATH:+:\$PATH}\"" $out/bin/amm

          if ! grep -qa "^export JAVA_HOME=" $out/bin/amm; then
            echo "failed to insert the environment ahead of exec" >&2
            exit 1
          fi
        '';

      passthru = {

        updateScript = {
          command = lib.getExe (writeShellApplication {
            name = "update-ammonite";

            runtimeInputs = [
              common-updater-scripts
              coreutils
              git
              gnugrep
              gnused
              jq
              nix
            ];

            text = ''
              # stdout is reserved for the JSON expected by the `commit`
              # updateScript feature, everything else has to go to stderr.
              #
              # $UPDATE_NIX_ATTR_PATH is deliberately ignored: one run refreshes
              # every variant, and the driver would hand us whichever one it
              # happened to walk into.
              nixpkgs=$(git rev-parse --show-toplevel)
              position=$(nix-instantiate --eval --raw --attr ammonite.meta.position "$nixpkgs")
              package_nix="''${position%:*}"
              old_version=$(nix-instantiate --eval --raw --attr ammonite.version "$nixpkgs")

              new_version=$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs \
                --sort='version:refname' --tags https://github.com/${owner}/${repo}.git '*.*.*' \
                | cut --delimiter='/' --fields=3 \
                | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
                | tail --lines=1)

              if [[ -z "$new_version" ]]; then
                echo "no plain X.Y.Z tag found upstream" >&2
                exit 1
              fi

              order=$(nix-instantiate --eval \
                --expr "builtins.compareVersions \"$new_version\" \"$old_version\"")

              case "$order" in
                0)
                  echo "ammonite is already at the latest version $new_version." >&2
                  echo '[]'
                  exit 0
                  ;;
                -1)
                  echo "refusing to downgrade ammonite from $old_version to $new_version." >&2
                  exit 1
                  ;;
              esac

              # Every variant shares the one version literal and has its own hash,
              # so put the file back if any of them fails partway.
              backup=$(mktemp)
              cp "$package_nix" "$backup"
              trap 'cp "$backup" "$package_nix"; rm -f "$backup"' EXIT

              refresh() {
                local attr="$1" scala_version="$2" hash
                hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url \
                  "https://github.com/${owner}/${repo}/releases/download/$new_version/$scala_version-$new_version")")

                # --ignore-same-version because the version literal is shared, so
                # only the first call changes it.
                update-source-version "$attr" "$new_version" "$hash" \
                  --version-key=version --ignore-same-version >&2
              }

              ${lib.concatStrings (
                lib.mapAttrsToList (attr: variant: ''
                  refresh ${attr} ${variant.scalaVersion}
                '') variants
              )}

              trap - EXIT
              rm -f "$backup"

              jq --null-input --compact-output \
                --arg oldVersion "$old_version" \
                --arg newVersion "$new_version" \
                --arg file "$package_nix" \
                '[ {
                  attrPath: "ammonite",
                  oldVersion: $oldVersion,
                  newVersion: $newVersion,
                  files: [ $file ],
                  commitBody: "https://github.com/${owner}/${repo}/releases/tag/\($newVersion)"
                } ]'
            '';
          });
          supportedFeatures = [ "commit" ];
        };
      };

      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck

        $out/bin/amm -h "$PWD" -c 'val foo = 21; println(foo * 2)' | grep 42

        runHook postInstallCheck
      '';

      meta = {
        description = "Improved Scala REPL, built for Scala ${scalaVersion}";
        longDescription = ''
          The Ammonite-REPL is an improved Scala REPL, re-implemented from first principles.
          It is much more featureful than the default REPL and comes
          with a lot of ergonomic improvements and configurability
          that may be familiar to people coming from IDEs or other REPLs such as IPython or Zsh.
        '';
        homepage = "https://github.com/${owner}/${repo}";
        changelog = "https://github.com/${owner}/${repo}/releases/tag/${version}";
        license = lib.licenses.mit;
        sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
        mainProgram = "amm";
        maintainers = with lib.maintainers; [
          agilesteel
          tbutter
        ];
        # a launcher script running a jar, so it runs wherever the jre does
        platforms = jre.meta.platforms;
      };
    };
in
lib.mapAttrs (_: common) variants
