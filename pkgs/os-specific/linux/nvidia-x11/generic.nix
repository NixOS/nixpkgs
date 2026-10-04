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
  # Older drivers carry no 32-bit libraries in their own archive and take them
  # from a separate i686 one, which a platform without 32-bit x86 support does
  # not fetch.
  disable32Bit ? stdenv.hostPlatform.system == "aarch64-linux",
  # Driver version and sources
  version,
  # Name of this driver branch, so that a driver and the modules built from
  # the same sources can be matched against each other. Callers using
  # `mkDriver` for an unlisted release get the version as the branch name.
  branch ? version,
  # Only set when instantiating the factory from `linuxPackages`, where the
  # same driver also builds its kernel modules.
  kernel ? null,
  # The kernel's common make flags. Passed only together with `kernel`, and
  # the module build needs them.
  kernelModuleMakeFlags ? [ ],
  url ? null,
  sha256_32bit ? null,
  sha256_64bit,
  sha256_aarch64 ? null,
  openSha256 ? null,
  # Passthru package hashes and versions
  settingsSha256 ? null,
  settingsVersion ? version,
  persistencedSha256 ? null,
  persistencedVersion ? version,
  fabricmanagerSha256 ? null,
  fabricmanagerVersion ? version,
  modprobeSha256 ? null,
  modprobeVersion ? version,
  # Whether to fetch the open-source kernel module sources from NVIDIA
  fetchOpenFromNvidia ? false,
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
# `makeScope` hands out a `callPackage` bound to the scope, and taking it
# forces every member, so a scope cannot carry the throwing names below.

lib.makeExtensible (
  self:
  let
    nvidiaDriver = self.driver;

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

    # The unpacked installer archive.  A member rather than something private to
    # `driver`, because the proprietary kernel module build reads the same tree,
    # and because the hash verifier in `maintainers/scripts/` looks for a
    # component whose `.src` carries the archive's URLs.
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

        # The 32-bit libraries of a driver that does not carry them in its own
        # archive, built from the i686 one.  Only where the host can build i686
        # at all, which rules out aarch64.
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
      # The main build: extracts the libraries, binaries and firmware from the
      # NVIDIA driver installer.
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
          inherit (nvidiaDriver.meta) platforms;
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
          }
        ) fabricmanagerSha256
      else
        null;

    modprobe = lib.mapNullable (
      hash:
      callPackage ./modprobe.nix {
        inherit hash fetchFromGithubOrNvidia;
        version = modprobeVersion;
        inherit (nvidiaDriver.meta) platforms;
      }
    ) modprobeSha256;

    inherit
      settingsVersion
      persistencedVersion
      fabricmanagerVersion
      modprobeVersion
      ;

  }
  // lib.optionalAttrs (!i686bundled && !disable32Bit && sha256_32bit != null) {
    # The i686 archive that older drivers take their 32-bit libraries from.  A
    # member so that its URLs sit on the branch, where the hash verifier in
    # `maintainers/scripts/` finds them.  It has to stay absent where there is
    # no such archive or the host cannot build i686, otherwise the member is an
    # evaluation error instead of a source.
    installer32 = pkgsi686Linux.callPackage ./installer.nix installerArgs;
  }
  // lib.optionalAttrs (kernel != null) {
    # The kernel modules only exist in the `linuxPackages` instantiation, where
    # `kernel` was passed in.
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
      broken = modulesBroken;
    };

    open = lib.mapNullable (
      hash:
      callPackage ./kernel-modules.nix {
        open = true;
        inherit
          hash
          kernel
          kernelModuleMakeFlags
          version
          branch
          ;
        src = self.installer;
        patches =
          (map (rewritePatch {
            from = "kernel";
            to = "kernel-open";
          }) patches)
          ++ patchesOpen;
        broken = modulesBroken;
        fetchFromGithubOrNvidia =
          if fetchOpenFromNvidia then
            fetchFromGithubOrNvidia
          else
            args:
            fetchFromGitHub (
              removeAttrs args [
                "nvrepo"
                "nvext"
                "postFetch"
              ]
            );
      }
    ) openSha256;

  }
  # What the driver's outputs and the module sources were called on the branch
  # itself. The release and eval configs turn `allowAliases` off, so these are
  # absent there and the release walk never reaches a warning or a throw.
  // lib.optionalAttrs config.allowAliases (
    lib.genAttrs [ "out" "bin" "firmware" "lib32" ] (
      name:
      if nvidiaDriver ? ${name} then
        lib.warnOnInstantiate "nvidiaPackages.${branch}.${name} is now .driver.${name}" nvidiaDriver.${name}
      else
        throw "nvidiaPackages.${branch} builds no '${name}' output, so .driver.${name} does not exist either"
    )
    // {
      modsrc = throw "nvidiaPackages.${branch}.modsrc has been removed. The kernel module is now built from the installer archive itself; see pkgs/os-specific/linux/nvidia-x11/README.md";
    }
  )
)
