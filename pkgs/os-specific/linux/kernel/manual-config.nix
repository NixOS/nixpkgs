{ lib, stdenv, buildPackages, runCommand, nettools, bc, bison, flex, perl, rsync, gmp, libmpc, mpfr, openssl
, libelf, cpio, elfutils, zstd, python3Minimal, zlib, pahole, kmod
, fetchpatch
}:

let
  lib_ = lib;
  stdenv_ = stdenv;

  readConfig = configfile: import (runCommand "config.nix" {} ''
    echo "{" > "$out"
    while IFS='=' read key val; do
      [ "x''${key#CONFIG_}" != "x$key" ] || continue
      no_firstquote="''${val#\"}";
      echo '  "'"$key"'" = "'"''${no_firstquote%\"}"'";' >> "$out"
    done < "${configfile}"
    echo "}" >> $out
  '').outPath;
in lib.makeOverridable ({
  # The kernel version
  version,
  # Position of the Linux build expression
  pos ? null,
  # Additional kernel make flags
  extraMakeFlags ? [],
  # The name of the kernel module directory
  # Needs to be X.Y.Z[-extra], so pad with zeros if needed.
  modDirVersion ? lib.versions.pad 3 version,
  # The kernel source (tarball, git checkout, etc.)
  src,
  # a list of { name=..., patch=..., extraConfig=...} patches
  kernelPatches ? [],
  # The kernel .config file
  configfile,
  # Manually specified nixexpr representing the config
  # If unspecified, this will be autodetected from the .config
  config ? lib.optionalAttrs allowImportFromDerivation (readConfig configfile),
  # Custom seed used for CONFIG_GCC_PLUGIN_RANDSTRUCT if enabled. This is
  # automatically extended with extra per-version and per-config values.
  randstructSeed ? "",
  # Extra meta attributes
  extraMeta ? {},

  # for module compatibility
  isZen      ? false,
  isLibre    ? false,
  isHardened ? false,

  # Whether to utilize the controversial import-from-derivation feature to parse the config
  allowImportFromDerivation ? false,
  # ignored
  features ? null, lib ? lib_, stdenv ? stdenv_,
}:

let
  inherit (lib)
    hasAttr getAttr optional optionals optionalString optionalAttrs maintainers platforms;

  # Dependencies that are required to build kernel modules
  moduleBuildDependencies = [
    pahole
    perl
    libelf
    # module makefiles often run uname commands to find out the kernel version
    (buildPackages.deterministic-uname.override { inherit modDirVersion; })
  ] ++ optional (lib.versionAtLeast version "5.13") zstd;

  drvAttrs = config_: kernelConf: kernelPatches: configfile:
    let
      config = let attrName = attr: "CONFIG_" + attr; in {
        isSet = attr: hasAttr (attrName attr) config;

        getValue = attr: if config.isSet attr then getAttr (attrName attr) config else null;

        isYes = attr: (config.getValue attr) == "y";

        isNo = attr: (config.getValue attr) == "n";

        isModule = attr: (config.getValue attr) == "m";

        isEnabled = attr: (config.isModule attr) || (config.isYes attr);

        isDisabled = attr: (!(config.isSet attr)) || (config.isNo attr);
      } // config_;

      isModular = config.isYes "MODULES";

      buildDTBs = kernelConf.DTB or false;

    in (optionalAttrs isModular { outputs = [ "out" "dev" ]; }) // {
      passthru = rec {
        inherit version modDirVersion config kernelPatches configfile
          moduleBuildDependencies stdenv;
        inherit isZen isHardened isLibre;
        isXen = lib.warn "The isXen attribute is deprecated. All Nixpkgs kernels that support it now have Xen enabled." true;
        baseVersion = lib.head (lib.splitString "-rc" version);
        kernelOlder = lib.versionOlder baseVersion;
        kernelAtLeast = lib.versionAtLeast baseVersion;
      };

      inherit src;

      patches =
        map (p: p.patch) kernelPatches
        # Required for deterministic builds along with some postPatch magic.
        ++ optional (lib.versionOlder version "5.19") ./randstruct-provide-seed.patch
        ++ optional (lib.versionAtLeast version "5.19") ./randstruct-provide-seed-5.19.patch
        # Linux 5.12 marked certain PowerPC-only symbols as GPL, which breaks
        # OpenZFS; this was fixed in Linux 5.19 so we backport the fix
        # https://github.com/openzfs/zfs/pull/13367
        ++ optional (lib.versionAtLeast version "5.12" &&
                     lib.versionOlder version "5.19" &&
                     stdenv.hostPlatform.isPower)
          (fetchpatch {
            url = "https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/patch/?id=d9e5c3e9e75162f845880535957b7fd0b4637d23";
            hash = "sha256-bBOyJcP6jUvozFJU0SPTOf3cmnTQ6ZZ4PlHjiniHXLU=";
          });

      postPatch = ''
        # Ensure that depmod gets resolved through PATH
        sed -i Makefile -e 's|= /sbin/depmod|= depmod|'

        # fixup for pre-5.4 kernels using the $(cd $foo && /bin/pwd) pattern
        # FIXME: remove when no longer needed
        substituteInPlace Makefile tools/scripts/Makefile.include --replace /bin/pwd pwd

        # Don't include a (random) NT_GNU_BUILD_ID, to make the build more deterministic.
        # This way kernels can be bit-by-bit reproducible depending on settings
        # (e.g. MODULE_SIG and SECURITY_LOCKDOWN_LSM need to be disabled).
        # See also https://kernelnewbies.org/BuildId
        sed -i Makefile -e 's|--build-id=[^ ]*|--build-id=none|'

        # Some linux-hardened patches now remove certain files in the scripts directory, so the file may not exist.
        [[ -f scripts/ld-version.sh ]] && patchShebangs scripts/ld-version.sh

        # Set randstruct seed to a deterministic but diversified value. Note:
        # we could have instead patched gen-random-seed.sh to take input from
        # the buildFlags, but that would require also patching the kernel's
        # toplevel Makefile to add a variable export. This would be likely to
        # cause future patch conflicts.
        for file in scripts/gen-randstruct-seed.sh scripts/gcc-plugins/gen-random-seed.sh; do
          if [ -f "$file" ]; then
            substituteInPlace "$file" \
              --replace NIXOS_RANDSTRUCT_SEED \
              $(echo ${randstructSeed}${src} ${placeholder "configfile"} | sha256sum | cut -d ' ' -f 1 | tr -d '\n')
            break
          fi
        done

        patchShebangs scripts

        # also patch arch-specific install scripts
        for i in $(find arch -name install.sh); do
            patchShebangs "$i"
        done
      '';

      configurePhase = ''
        runHook preConfigure

        mkdir build
        export buildRoot="$(pwd)/build"

        echo "manual-config configurePhase buildRoot=$buildRoot pwd=$PWD"

        if [ -f "$buildRoot/.config" ]; then
          echo "Could not link $buildRoot/.config : file exists"
          exit 1
        fi
        ln -sv ${configfile} $buildRoot/.config

        # reads the existing .config file and prompts the user for options in
        # the current kernel source that are not found in the file.
        make $makeFlags "''${makeFlagsArray[@]}" oldconfig
        runHook postConfigure

        make $makeFlags "''${makeFlagsArray[@]}" prepare
        actualModDirVersion="$(cat $buildRoot/include/config/kernel.release)"
        if [ "$actualModDirVersion" != "${modDirVersion}" ]; then
          echo "Error: modDirVersion ${modDirVersion} specified in the Nix expression is wrong, it should be: $actualModDirVersion"
          exit 1
        fi

        buildFlagsArray+=("KBUILD_BUILD_TIMESTAMP=$(date -u -d @$SOURCE_DATE_EPOCH)")

        cd $buildRoot
      '';

      buildFlags = [
        "KBUILD_BUILD_VERSION=1-NixOS"
        kernelConf.target
        "vmlinux"  # for "perf" and things like that
      ] ++ optional isModular "modules"
        ++ optionals buildDTBs ["dtbs" "DTC_FLAGS=-@"]
      ++ extraMakeFlags;

      installFlags = [
        "INSTALL_PATH=$(out)"
      ] ++ (optional isModular "INSTALL_MOD_PATH=$(out)")
      ++ optionals buildDTBs ["dtbs_install" "INSTALL_DTBS_PATH=$(out)/dtbs"];

      preInstall = let
        # All we really need to do here is copy the final image and System.map to $out,
        # and use the kernel's modules_install, firmware_install, dtbs_install, etc. targets
        # for the rest. Easy, right?
        #
        # Unfortunately for us, the obvious way of getting the built image path,
        # make -s image_name, does not work correctly, because some architectures
        # (*cough* aarch64 *cough*) change KBUILD_IMAGE on the fly in their install targets,
        # so we end up attempting to install the thing we didn't actually build.
        #
        # Thankfully, there's a way out that doesn't involve just hardcoding everything.
        #
        # The kernel has an install target, which runs a pretty simple shell script
        # (located at scripts/install.sh or arch/$arch/boot/install.sh, depending on
        # which kernel version you're looking at) that tries to do something sensible.
        #
        # (it would be great to hijack this script immediately, as it has all the
        #   information we need passed to it and we don't need it to try and be smart,
        #   but unfortunately, the exact location of the scripts differs between kernel
        #   versions, and they're seemingly not considered to be public API at all)
        #
        # One of the ways it tries to discover what "something sensible" actually is
        # is by delegating to what's supposed to be a user-provided install script
        # located at ~/bin/installkernel.
        #
        # (the other options are:
        #   - a distribution-specific script at /sbin/installkernel,
        #        which we can't really create in the sandbox easily
        #   - an architecture-specific script at arch/$arch/boot/install.sh,
        #        which attempts to guess _something_ and usually guesses very wrong)
        #
        # More specifically, the install script exec's into ~/bin/installkernel, if one
        # exists, with the following arguments:
        #
        # $1: $KERNELRELEASE - full kernel version string
        # $2: $KBUILD_IMAGE - the final image path
        # $3: System.map - path to System.map file, seemingly hardcoded everywhere
        # $4: $INSTALL_PATH - path to the destination directory as specified in installFlags
        #
        # $2 is exactly what we want, so hijack the script and use the knowledge given to it
        # by the makefile overlords for our own nefarious ends.
        #
        # Note that the makefiles specifically look in ~/bin/installkernel, and
        # writeShellScriptBin writes the script to <store path>/bin/installkernel,
        # so HOME needs to be set to just the store path.
        #
        # FIXME: figure out a less roundabout way of doing this.
        installkernel = buildPackages.writeShellScriptBin "installkernel" ''
          cp -av $2 $4
          cp -av $3 $4
        '';
      in ''
        installFlagsArray+=("-j$NIX_BUILD_CORES")
        export HOME=${installkernel}
      '';

      # Some image types need special install targets (e.g. uImage is installed with make uinstall)
      installTargets = [
        (kernelConf.installTarget or (
          /**/ if kernelConf.target == "uImage" then "uinstall"
          else if kernelConf.target == "zImage" || kernelConf.target == "Image.gz" then "zinstall"
          else "install"))
      ];

      postInstall = optionalString isModular ''
        mkdir -p $dev
        cp vmlinux $dev/
        if [ -z "''${dontStrip-}" ]; then
          installFlagsArray+=("INSTALL_MOD_STRIP=1")
        fi
        make modules_install $makeFlags "''${makeFlagsArray[@]}" \
          $installFlags "''${installFlagsArray[@]}"
        unlink $out/lib/modules/${modDirVersion}/build
        rm -f $out/lib/modules/${modDirVersion}/source

        mkdir -p $dev/lib/modules/${modDirVersion}/{build,source}

        # To save space, exclude a bunch of unneeded stuff when copying.
        (cd .. && rsync --archive --prune-empty-dirs \
            --exclude='/build/' \
            * $dev/lib/modules/${modDirVersion}/source/)

        cd $dev/lib/modules/${modDirVersion}/source

        cp $buildRoot/{.config,Module.symvers} $dev/lib/modules/${modDirVersion}/build
        make modules_prepare $makeFlags "''${makeFlagsArray[@]}" O=$dev/lib/modules/${modDirVersion}/build

        # For reproducibility, removes accidental leftovers from a `cc1` call
        # from a `try-run` call from the Makefile
        rm -f $dev/lib/modules/${modDirVersion}/build/.[0-9]*.d

        # Keep some extra files on some arches (powerpc, aarch64)
        for f in arch/powerpc/lib/crtsavres.o arch/arm64/kernel/ftrace-mod.o; do
          if [ -f "$buildRoot/$f" ]; then
            cp $buildRoot/$f $dev/lib/modules/${modDirVersion}/build/$f
          fi
        done

        # !!! No documentation on how much of the source tree must be kept
        # If/when kernel builds fail due to missing files, you can add
        # them here. Note that we may see packages requiring headers
        # from drivers/ in the future; it adds 50M to keep all of its
        # headers on 3.10 though.

        chmod u+w -R ..
        arch=$(cd $dev/lib/modules/${modDirVersion}/build/arch; ls)

        # Remove unused arches
        for d in $(cd arch/; ls); do
          if [ "$d" = "$arch" ]; then continue; fi
          if [ "$arch" = arm64 ] && [ "$d" = arm ]; then continue; fi
          rm -rf arch/$d
        done

        # Remove all driver-specific code (50M of which is headers)
        rm -fR drivers

        # Keep all headers
        find .  -type f -name '*.h' -print0 | xargs -0 -r chmod u-w

        # Keep linker scripts (they are required for out-of-tree modules on aarch64)
        find .  -type f -name '*.lds' -print0 | xargs -0 -r chmod u-w

        # Keep root and arch-specific Makefiles
        chmod u-w Makefile arch/"$arch"/Makefile*

        # Keep whole scripts dir
        chmod u-w -R scripts

        # Delete everything not kept
        find . -type f -perm -u=w -print0 | xargs -0 -r rm

        # Delete empty directories
        find -empty -type d -delete
      '';

      requiredSystemFeatures = [ "big-parallel" ];

      meta = {
        description =
          "The Linux kernel" +
          (if kernelPatches == [] then "" else
            " (with patches: "
            + lib.concatStringsSep ", " (map (x: x.name) kernelPatches)
            + ")");
        license = lib.licenses.gpl2Only;
        homepage = "https://www.kernel.org/";
        maintainers = lib.teams.linux-kernel.members ++ [
          maintainers.thoughtpolice
        ];
        platforms = platforms.linux;
        badPlatforms =
          lib.optionals (lib.versionOlder version "4.15") [ "riscv32-linux" "riscv64-linux" ] ++
          lib.optional (lib.versionOlder version "5.19") "loongarch64-linux";
        timeout = 14400; # 4 hours
      } // extraMeta;
    };
in

assert lib.versionOlder version "5.8" -> libelf != null;
assert lib.versionAtLeast version "5.8" -> elfutils != null;

stdenv.mkDerivation ((drvAttrs config stdenv.hostPlatform.linux-kernel kernelPatches configfile) // {
  pname = "linux";
  inherit version;

  enableParallelBuilding = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl bc nettools openssl rsync gmp libmpc mpfr zstd python3Minimal kmod ]
      ++ optional  (stdenv.hostPlatform.linux-kernel.target == "uImage") buildPackages.ubootTools
      ++ optional  (lib.versionOlder version "5.8") libelf
      ++ optionals (lib.versionAtLeast version "4.16") [ bison flex ]
      ++ optionals (lib.versionAtLeast version "5.2")  [ cpio pahole zlib ]
      ++ optional  (lib.versionAtLeast version "5.8")  elfutils
      ;

  hardeningDisable = [ "bindnow" "format" "fortify" "stackprotector" "pic" "pie" ];

  # Absolute paths for compilers avoid any PATH-clobbering issues.
  makeFlags = [
    "O=$(buildRoot)"
    "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "HOSTCC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
    "HOSTLD=${buildPackages.stdenv.cc.bintools}/bin/${buildPackages.stdenv.cc.targetPrefix}ld"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ] ++ (stdenv.hostPlatform.linux-kernel.makeFlags or [])
    ++ extraMakeFlags;

  karch = stdenv.hostPlatform.linuxArch;
} // (optionalAttrs (pos != null) { inherit pos; })))
