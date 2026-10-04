{
  lib,
  stdenvNoCC,
  fetchurl,
  # Whether the user accepts the NVIDIA Software License.
  config,
  # Extraction: the Makeself preamble drives these, and the payload may be
  # compressed with any of them.
  coreutils,
  gawk,
  gnugrep,
  gnused,
  gnutar,
  libarchive,
  which,
  zstd,
  version,
  url ? null,
  sha256_32bit ? null,
  sha256_64bit,
  sha256_aarch64 ? null,
  acceptLicense ? config.nvidia.acceptLicense or false,
  openSha256 ? null,
}:

let
  # Throw an error about license acceptance
  throwLicense = throw ''
    Use of NVIDIA Software requires license acceptance of the license:

      - License For Customer Use of NVIDIA Software [1]

    You can express acceptance by setting acceptLicense to true your nixpkgs.config.
    Example:

      configuration.nix:
        nixpkgs.config.allowUnfree = true;
        nixpkgs.config.nvidia.acceptLicense = true;

      config.nix:
        allowUnfree = true;
        nvidia.acceptLicense = true;

    [1]: https://www.nvidia.com/content/DriverDownloads/licence.php?lang=us
  '';

  pkgSuffix = lib.optionalString (lib.versionOlder version "304") "-pkg0";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nvidia-installer-source";
  inherit version;

  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
    in
    if !acceptLicense && openSha256 == null then
      throwLicense
    else if system == "x86_64-linux" then
      fetchurl {
        urls =
          if url != null then
            [ url ]
          else
            [
              "https://us.download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}${pkgSuffix}.run"
              "https://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}${pkgSuffix}.run"
            ];
        sha256 = sha256_64bit;
      }
    else if system == "i686-linux" && sha256_32bit != null then
      fetchurl {
        urls =
          if url != null then
            [ url ]
          else
            [
              "https://us.download.nvidia.com/XFree86/Linux-x86/${version}/NVIDIA-Linux-x86-${version}${pkgSuffix}.run"
              "https://download.nvidia.com/XFree86/Linux-x86/${version}/NVIDIA-Linux-x86-${version}${pkgSuffix}.run"
            ];
        sha256 = sha256_32bit;
      }
    else if system == "aarch64-linux" && sha256_aarch64 != null then
      fetchurl {
        urls =
          if url != null then
            [ url ]
          else
            [
              "https://us.download.nvidia.com/XFree86/aarch64/${version}/NVIDIA-Linux-aarch64-${version}${pkgSuffix}.run"
              "https://download.nvidia.com/XFree86/Linux-aarch64/${version}/NVIDIA-Linux-aarch64-${version}${pkgSuffix}.run"
            ];
        sha256 = sha256_aarch64;
      }
    else
      throw "nvidia-x11 does not support platform ${system}";

  nativeBuildInputs = [
    coreutils
    gawk
    gnugrep
    gnused
    gnutar
    libarchive
    which
    zstd
  ];

  # The installer is a Makeself archive. Unpack it once so both builds read the
  # same tree instead of extracting the archive twice.
  dontUnpack = true;
  dontBuild = true;
  # Both consumers copy what they need and run their own fixup, so the output
  # stays the extracted files unchanged.
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    # Every installer is a shell script, but not every one is called `.run`:
    # the Vulkan developer driver comes as `vulkan-beta-<version>-linux`.
    if ! head -c 2 "$src" | grep -q '#!'; then
      echo "$src is not a shell archive" >&2
      exit 1
    fi

    extracted=$(mktemp -d)
    cd "$extracted"

    if ! sh "$src" -x; then
      echo "the installer's own extraction step failed; extracting the embedded tarball" >&2

      # The archive also embeds a plain tarball after a `skip=` line.
      skip=$(sed 's/^skip=//; t; d' "$src")
      tail -n +"$skip" "$src" | bsdtar xvf -
    fi

    # A Makeself extractor leaves one directory holding the payload; the
    # consumers expect its contents at the source root.
    if [ "$(ls -A | wc -l)" -eq 1 ] && [ -d "$(ls -A)" ]; then
      payload=$(ls -A)
    else
      payload=.
    fi

    mkdir -p $out
    cp -a "$payload"/. $out/

    runHook postInstall
  '';

  # No packaged executable reports the driver version without a loaded driver, so
  # check that the unpacked libraries are named after it, catching a stale archive.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    if ! { set -- "$out"/*.so."$version"; [ $# -gt 0 ]; }; then
      echo "no library is named after version $version, the driver archive is not the expected version:" >&2
      ls "$out" >&2 || true
      exit 1
    fi
    runHook postInstallCheck
  '';

  passthru.is32Bit = stdenvNoCC.hostPlatform.system == "i686-linux";

  meta = {
    homepage = "https://www.nvidia.com/object/unix.html";
    description = "Unpacked NVIDIA driver installer, shared by the userspace and kernel module builds";
    # The contents are the proprietary driver, so this must not look like a
    # free package: Hydra and the release eval filter on this and skip it.
    license = lib.licenses.unfreeRedistributable;
    platforms = [
      "x86_64-linux"
    ]
    ++ lib.optional (sha256_32bit != null) "i686-linux"
    ++ lib.optional (sha256_aarch64 != null) "aarch64-linux";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
