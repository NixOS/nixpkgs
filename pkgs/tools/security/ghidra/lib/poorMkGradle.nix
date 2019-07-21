# NOTE This is already partially applied over Ghidra, which is
# why Ghidra doesn't need to be directly mentioned in a plugin
# definition, even though they depend on the builder script in
# the Ghidra distribution.

# NOTE that JDK11 is the version of Java currently required by
# Ghidra, and the Gradle JDK must be overridden to it. See the
# definition in the base_packages layer.
 
# based on https://github.com/NixOS/nixpkgs/blob/c62742719bca11070552f5050204c09ba0df14e2/pkgs/tools/security/jd-gui/default.nix
# per https://github.com/NixOS/nixpkgs/issues/17342
# TODO should be replaced when and if gradle integration happens
{stdenv, gradleGen, ghidra, config}:
    name: src: stdenv.mkDerivation {
      name = name + ".zip";

      inherit src;

      nativeBuildInputs = [
        gradleGen
        ];

      # noCheckInputs = "true"; #Disable disallowing injesting JARs in plugins

      # TODO: this is a hack to work around all the plugins getting the same archive and directory name
      # The builder seems to just use the name of parent directory as opposed to whats in the configs.
      setSourceRoot = ''
        mv source '${name}'
        sourceRoot='${name}'
        '';

    # Filter ingested plugin jars, get new jars   
    jarsForPreBuild = ''
        runHook removeJars
        findOut=$(find . -type f -iname '*.jar')
        if [[ "$findOut" && (! "$noCheckInputs") ]]; then
          echo "Don't use random (sketchy) JARs off random repos! (I'm not checking anything else. Audit your inputs!)"
          echo "$findOut"
          exit 1
          fi
        runHook addJars
        '';

      buildPhase = ''
        runHook jarsForPreBuild

        GHIDRA_INSTALL_DIR='${ghidra + "/" + config.pkg_path}' gradle --offline --no-daemon buildExtension
        '';

      installPhase = ''
         cp dist/*.zip $out
        '';
      }
