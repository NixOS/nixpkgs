# Single-function interface: takes both package dependencies (auto-resolved
# by callPackage in default.nix) and driver-specific arguments.
#
# The attrset passed to binaries.nix is constructed explicitly via driverArgs
# so that every parameter (including defaults) is resolved before reaching
# binaries.nix — binaries.nix only keeps defaults for disable32Bit, firmware,
# and acceptLicense.
{
  # Package dependencies (auto-resolved by callPackage)
  lib,
  runCommandLocal,
  patchutils,
  callPackage,
  pkgsi686Linux,
  fetchzip,
  fetchFromGitHub,
  libsOnly ? false,
  # Driver version and sources
  version,
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
  broken ? false,
  brokenOpen ? broken,
}:

assert useSettings -> settingsSha256 != null;
assert usePersistenced -> persistencedSha256 != null;
assert useFabricmanager -> fabricmanagerSha256 != null;
assert useFabricmanager -> !useSettings;

let
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

  # The main build: extracts libraries, binaries, kernel module sources
  # and firmware from the NVIDIA driver installer.
  nvidiaDriver =
    let
      # Driver arguments shared between the main build and the i686 lib32 build.
      # Constructed explicitly so that every parameter (including defaults) is
      # resolved before reaching binaries.nix.
      driverArgs = {
        inherit
          version
          url
          sha256_32bit
          sha256_64bit
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
          broken
          brokenOpen
          ;
      };
    in
    callPackage ./binaries.nix (
      driverArgs
      // {
        inherit libsOnly;
        lib32 =
          (pkgsi686Linux.callPackage ./binaries.nix (
            driverArgs
            // {
              libsOnly = true;
              lib32 = null;
              firmware = false;
            }
          )).out;
      }
    );
in
nvidiaDriver.overrideAttrs (
  finalAttrs: prevAttrs: {
    passthru = lib.recursiveUpdate prevAttrs.passthru {
      mod =
        if !libsOnly then
          callPackage ./kernel-modules.nix {
            open = false;
            nvidia_x11 = finalAttrs.finalPackage;
            # build files already patched when building the main package,
            # so no need to patch them again
            patches = [ ];
            inherit broken fetchFromGithubOrNvidia;
          }
        else
          { };
      open = lib.mapNullable (
        hash:
        callPackage ./kernel-modules.nix {
          open = true;
          inherit hash;
          nvidia_x11 = finalAttrs.finalPackage;
          patches =
            (map (rewritePatch {
              from = "kernel";
              to = "kernel-open";
            }) patches)
            ++ patchesOpen;
          broken = brokenOpen;
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
      settings =
        if useSettings then
          (if settings32Bit then pkgsi686Linux.callPackage else callPackage) ./settings.nix {
            nvidia_x11 = finalAttrs.finalPackage;
            version = settingsVersion;
            hash = settingsSha256;
            withGtk2 = preferGtk2;
            withGtk3 = !preferGtk2;
            inherit fetchFromGithubOrNvidia;
          }
        else
          { };
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
          { };
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
          { };
      inherit
        settingsVersion
        persistencedVersion
        fabricmanagerVersion
        ;
    };
  }
)
