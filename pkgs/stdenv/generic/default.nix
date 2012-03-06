{ system, name ? "stdenv", preHook ? "", initialPath, gcc, shell
, extraAttrs ? {}, overrides ? (pkgs: {})

, # The `fetchurl' to use for downloading curl and its dependencies
  # (see all-packages.nix).
  fetchurlBoot
}:

let

  lib = import ../../lib;

  stdenvGenerator = setupScript: rec {

    # The stdenv that we are producing.
    result =

      derivation {
        inherit system name;

        builder = shell;

        args = ["-e" ./builder.sh];

        setup = setupScript;

        inherit preHook initialPath gcc shell;

        propagatedUserEnvPkgs = [gcc] ++
          lib.filter lib.isDerivation initialPath;
      }

      // {

        meta = {
          description = "The default build environment for Unix packages in Nixpkgs";
        };

        # Add a utility function to produce derivations that use this
        # stdenv and its shell.
        mkDerivation = attrs:
          (derivation (
            (removeAttrs attrs ["meta" "passthru" "crossAttrs"])
            // (let
                buildInputs = if attrs ? buildInputs then attrs.buildInputs
                    else [];
                buildNativeInputs = if attrs ? buildNativeInputs then
                    attrs.buildNativeInputs else [];
                propagatedBuildInputs = if attrs ? propagatedBuildInputs then
                    attrs.propagatedBuildInputs else [];
                propagatedBuildNativeInputs = if attrs ?
                    propagatedBuildNativeInputs then
                    attrs.propagatedBuildNativeInputs else [];
                crossConfig = if (attrs ? crossConfig) then attrs.crossConfig else
                   null;
            in
            {
              builder = if attrs ? realBuilder then attrs.realBuilder else shell;
              args = if attrs ? args then attrs.args else
                ["-e" (if attrs ? builder then attrs.builder else ./default-builder.sh)];
              stdenv = result;
              system = result.system;

              # That build by the cross compiler
              buildInputs = lib.optionals (crossConfig != null) buildInputs;
              propagatedBuildInputs = lib.optionals (crossConfig != null)
                  propagatedBuildInputs;
              # That build by the usual native compiler
              buildNativeInputs = buildNativeInputs ++ lib.optionals
                (crossConfig == null) buildInputs;
              propagatedBuildNativeInputs = propagatedBuildNativeInputs ++
                lib.optionals (crossConfig == null) propagatedBuildInputs;
            }))
          )
          # The meta attribute is passed in the resulting attribute set,
          # but it's not part of the actual derivation, i.e., it's not
          # passed to the builder and is not a dependency.  But since we
          # include it in the result, it *is* available to nix-env for
          # queries.
          //
          { meta = if attrs ? meta then attrs.meta else {}; }
          # Pass through extra attributes that are not inputs, but
          # should be made available to Nix expressions using the
          # derivation (e.g., in assertions).
          //
          (if attrs ? passthru then attrs.passthru else {});

        # Utility flags to test the type of platform.
        isDarwin = result.system == "i686-darwin"
               || result.system == "powerpc-darwin"
               || result.system == "x86_64-darwin";
        isLinux = result.system == "i686-linux"
               || result.system == "x86_64-linux"
               || result.system == "powerpc-linux"
               || result.system == "armv5tel-linux"
               || result.system == "mips64el-linux";
        isGNU = result.system == "i686-gnu";      # GNU/Hurd
        isSunOS = result.system == "i686-solaris"
               || result.system == "x86_64-solaris";
        isCygwin = result.system == "i686-cygwin";
        isFreeBSD = result.system == "i686-freebsd"
               || result.system == "x86_64-freebsd";
        isOpenBSD = result.system == "i686-openbsd"
               || result.system == "x86_64-openbsd";
        isBSD = result.system == "i686-freebsd"
               || result.system == "x86_64-freebsd"
               || result.system == "i686-openbsd"
               || result.system == "x86_64-openbsd";
        isi686 = result.system == "i686-linux"
               || result.system == "i686-gnu"
               || result.system == "i686-darwin"
               || result.system == "i686-freebsd"
               || result.system == "i686-openbsd"
               || result.system == "i386-sunos";
        isx86_64 = result.system == "x86_64-linux"
               || result.system == "x86_64-darwin"
               || result.system == "x86_64-freebsd"
               || result.system == "x86_64-openbsd";
        is64bit = result.system == "x86_64-linux"
                || result.system == "x86_64-darwin";
        isMips = result.system == "mips-linux"
                || result.system == "mips64el-linux";
        isArm = result.system == "armv5tel-linux";

        # Utility function: allow stdenv to be easily regenerated with
        # a different setup script.  (See all-packages.nix for an
        # example.)
        regenerate = stdenvGenerator;

        # For convenience, bring in the library functions in lib/ so
        # packages don't have to do that themselves.
        inherit lib;

        inherit fetchurlBoot;

        inherit overrides;
      }

      # Propagate any extra attributes.  For instance, we use this to
      # "lift" packages like curl from the final stdenv for Linux to
      # all-packages.nix for that platform (meaning that it has a line
      # like curl = if stdenv ? curl then stdenv.curl else ...).
      // extraAttrs;

  }.result;


in stdenvGenerator ./setup.sh
