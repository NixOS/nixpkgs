{
  # Package dependencies
  lib,
  stdenv,
  config,
  runCommandLocal,
  patchutils,
  callPackage,
  pkgsi686Linux,
  fetchzip,
  fetchFromGitHub,

  libsOnly ? false,
  # Older drivers take their 32-bit libraries from a separate i686 archive,
  # which a host without 32-bit x86 support does not fetch.
  disable32Bit ? stdenv.hostPlatform.system == "aarch64-linux",
  # Driver version and sources
  version,
  # Name of this driver branch, shared with the kernel modules built from the
  # same sources.
  branch ? version,
  # Only set from `linuxPackages`, where the same driver builds its kernel modules.
  kernel ? null,
  # The kernel's common make flags, needed by the module build and passed only with `kernel`.
  kernelModuleMakeFlags ? [ ],
  url ? null,
  sha256_32bit ? null,
  sha256_64bit,
  sha256_aarch64 ? null,
  openSha256 ? null,
  # Hashes and versions of the companion packages
  settingsSha256 ? null,
  settingsVersion ? version,
  persistencedSha256 ? null,
  persistencedVersion ? version,
  fabricmanagerSha256 ? null,
  fabricmanagerVersion ? version,
  # Every branch of `nvidiaPackages` carries nvidia-modprobe; the NixOS module
  # needs it for its udev rules, so it is not optional.
  modprobeSha256,
  modprobeVersion ? version,
  # Feature flags
  useGLVND ? true,
  useProfiles ? true,
  preferGtk2 ? false,
  settings32Bit ? false,
  useSettings ? true,
  usePersistenced ? true,
  useFabricmanager ? false,
  ibtSupport ? false,
  # Build customization
  prePatch ? null,
  postPatch ? null,
  patchFlags ? null,
  patches ? [ ],
  patchesOpen ? [ ],
  preInstall ? null,
  postInstall ? null,
  # Kernel modules from these sources do not build against this kernel version
  # or newer. The userspace libraries have no such limit.
  brokenFrom ? null,
}:

assert useSettings -> settingsSha256 != null;
assert usePersistenced -> persistencedSha256 != null;
assert useFabricmanager -> fabricmanagerSha256 != null;
assert useFabricmanager -> !useSettings;
# `makeExtensible` keeps the throwing names below lazy; `makeScope`'s bound
# `callPackage` would force every member.

lib.makeExtensible (
  self:
  let
    nvidiaDriver = self.driver;

    # The old member spellings of a branch: the driver's outputs, plus the
    # 32-bit libraries, which are an output where the archive carries them and
    # a `passthru` member elsewhere. Like ./binaries.nix's `outputs`, this is
    # derived from the branch's parameters instead of probed on `nvidiaDriver`:
    # probing would force the driver, and with it this scope, while the scope
    # is being built, which Nix rejects as infinite recursion.
    driverAliases = [
      "out"
    ]
    ++ lib.optionals (!libsOnly) [ "bin" ]
    ++ lib.optionals (!libsOnly && (openSha256 != null || useFabricmanager)) [ "firmware" ]
    ++ lib.optional (!disable32Bit) "lib32";

    modulesBroken = brokenFrom != null && kernel.kernelAtLeast brokenFrom;

    # The installer is a Makeself archive that both the userspace build and the
    # kernel module build read, so it is unpacked once, for each platform.
    installerArgs = {
      inherit
        version
        url
        sha256_32bit
        sha256_64bit
        sha256_aarch64
        openSha256
        ;
    };

    # Drivers from 391 on carry the 32-bit libraries in their own archive;
    # older ones come from a separate i686 archive, fetched as its own source.
    i686bundled = lib.versionAtLeast version "391" && !disable32Bit;

    fetchFromGithubOrNvidia =
      {
        owner,
        repo,
        tag,
        nvrepo ? repo,
        nvext ? "bz2",
        ...
      }@fetchArgs:
      let
        fetchArgs' = removeAttrs fetchArgs [
          "owner"
          "repo"
          "tag"
          "nvrepo"
          "nvext"
        ];
        baseUrl = "https://github.com/${owner}/${repo}";
      in
      fetchzip (
        fetchArgs'
        // {
          urls = [
            "${baseUrl}/archive/${tag}.tar.gz"
            "https://download.nvidia.com/XFree86/${nvrepo}/${nvrepo}-${tag}.tar.${nvext}"
          ];
          # github and nvidia use different compression algorithms,
          # use an invalid file extension to force detection.
          extension = "tar.??";
          # do not try to retry 4xx errors
          curlOptsList = [ "--no-retry-all-errors" ];
        }
      );

    # Rewrites patches meant for the kernel/* folder structure to kernel-open/*
    rewritePatch =
      { from, to }:
      patch:
      runCommandLocal (baseNameOf patch)
        {
          inherit patch;
          nativeBuildInputs = [ patchutils ];
        }
        ''
          lsdiff \
            -p1 -i ${from}/'*' \
            "$patch" \
          | sort -u | sed -e 's/[*?]/\\&/g' \
          | xargs -I{} \
            filterdiff \
            --include={} \
            --strip=2 \
            --addoldprefix=a/${to}/ \
            --addnewprefix=b/${to}/ \
            --clean "$patch" > "$out"
        '';
  in
  {
    inherit
      branch
      version
      ibtSupport
      useGLVND
      useProfiles
      ;

    # Unpacked installer archive, exposed as a member so the proprietary kernel
    # module build reads the same tree and the hash verifier in
    # `maintainers/scripts/` finds the archive URLs on `.src`.
    installer = callPackage ./installer.nix installerArgs;

    driver =
      let
        # Driver arguments shared between the main build and the i686 lib32 build.
        driverArgs = {
          inherit
            version
            sha256_32bit
            sha256_aarch64
            openSha256
            useGLVND
            useProfiles
            useFabricmanager
            ibtSupport
            prePatch
            postPatch
            patchFlags
            patches
            preInstall
            postInstall
            i686bundled
            ;
        };

        # 32-bit libraries taken from the separate i686 archive, since the
        # driver's own archive has none. Only on hosts that build i686, which
        # rules out aarch64.
        driverLib32 =
          if i686bundled || disable32Bit then
            null
          else
            pkgsi686Linux.callPackage ./binaries.nix (
              driverArgs
              // {
                src = self.installer32;
                libsOnly = true;
                lib32 = null;
                firmware = false;
              }
            );
      in
      # Extracts the libraries, binaries and firmware from the installer.
      callPackage ./binaries.nix (
        driverArgs
        // {
          src = self.installer;
          inherit libsOnly;
          lib32 = if driverLib32 == null then null else driverLib32.out;
        }
      );

    settings =
      if useSettings then
        (if settings32Bit then pkgsi686Linux.callPackage else callPackage) ./settings.nix {
          version = settingsVersion;
          hash = settingsSha256;
          withGtk2 = preferGtk2;
          withGtk3 = !preferGtk2;
          inherit fetchFromGithubOrNvidia useProfiles;
          supportedPlatforms = nvidiaDriver.meta.platforms;
        }
      else
        null;

    persistenced =
      if usePersistenced then
        lib.mapNullable (
          hash:
          callPackage ./persistenced.nix {
            version = persistencedVersion;
            inherit fetchFromGithubOrNvidia hash;
            supportedPlatforms = nvidiaDriver.meta.platforms;
          }
        ) persistencedSha256
      else
        null;

    fabricmanager =
      if useFabricmanager then
        lib.mapNullable (
          hash:
          callPackage ./fabricmanager.nix {
            version = fabricmanagerVersion;
            inherit hash;
            supportedPlatforms = nvidiaDriver.meta.platforms;
          }
        ) fabricmanagerSha256
      else
        null;

    modprobe = callPackage ./modprobe.nix {
      hash = modprobeSha256;
      inherit fetchFromGithubOrNvidia;
      version = modprobeVersion;
      supportedPlatforms = nvidiaDriver.meta.platforms;
    };

    inherit
      settingsVersion
      persistencedVersion
      fabricmanagerVersion
      modprobeVersion
      ;

  }
  // lib.optionalAttrs (!i686bundled && !disable32Bit && sha256_32bit != null) {
    # i686 archive older drivers take their 32-bit libraries from, kept on the
    # branch for the hash verifier in `maintainers/scripts/`. Absent without such
    # an archive or a host that builds i686, where it would be an evaluation error.
    installer32 = pkgsi686Linux.callPackage ./installer.nix installerArgs;
  }
  // lib.optionalAttrs (kernel != null) {
    # Kernel modules exist only in the `linuxPackages` instantiation, which
    # passes `kernel`.
    mod = callPackage ./kernel-modules.nix {
      open = false;
      inherit fetchFromGithubOrNvidia;
      inherit prePatch patches patchFlags;
      inherit
        kernel
        kernelModuleMakeFlags
        version
        branch
        ;
      src = self.installer;
      # The installer archive exists only for the platforms the branch carries
      # a hash for.
      supportedPlatforms = [ "x86_64-linux" ] ++ lib.optional (sha256_aarch64 != null) "aarch64-linux";
      # The kernel's stdenv, like every other out-of-tree module.
      inherit (kernel) stdenv;
      broken = modulesBroken;
    };

    open = lib.mapNullable (
      hash:
      callPackage ./kernel-modules.nix {
        open = true;
        # Fetched from source, so the default `supportedPlatforms` applies.
        inherit
          hash
          kernel
          kernelModuleMakeFlags
          version
          branch
          ;
        patches =
          (map (rewritePatch {
            from = "kernel";
            to = "kernel-open";
          }) patches)
          ++ patchesOpen;
        inherit (kernel) stdenv;
        broken = modulesBroken;
        inherit fetchFromGithubOrNvidia;
      }
    ) openSha256;

  }
  # Old output and module-source spellings on the branch. The release and eval
  # configs disable `allowAliases`, so the release walk never reaches a warning
  # or a throw.
  // lib.optionalAttrs config.allowAliases (
    # `driverAliases` names exactly the members the driver has, so one it lacks
    # stays absent and `? firmware`-style capability probes keep working.
    lib.genAttrs driverAliases (
      name:
      lib.warnOnInstantiate "nvidiaPackages.${branch}.${name} is now .driver.${name}" nvidiaDriver.${name}
    )
    // {
      modsrc = throw "nvidiaPackages.${branch}.modsrc has been removed. The kernel module is now built from the installer archive itself; see pkgs/os-specific/linux/nvidia-x11/README.md";
    }
  )
)
