{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  kernel,
}:

let
  version = "6.30.223.271";
  hashes = {
    i686-linux = "sha256-T4twspOsjMXHDlca1dGHjQ8p0TOkb+eGmGjZwZtQWM0=";
    x86_64-linux = "sha256-X3l3TVvuyPdja1nA+wegMQju8eP9MkVjiyCFjHFBRL4=";
  };

  arch = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") "_64";
  tarballVersion = lib.replaceStrings [ "." ] [ "_" ] version;
  tarball = "hybrid-v35${arch}-nodebug-pcoem-${tarballVersion}.tar.gz";

  rpmFusionPatches = fetchFromGitHub {
    owner = "rpmfusion";
    repo = "wl-kmod";
    rev = "a04330284bfc38fd91eade6f8b28fa63cfcdc95e";
    hash = "sha256-c72Pr/v+nxZPLEeNKbWnSpbH3gqYZaTgzMO9PlYQkf0=";
  };
  patchset = [
    "wl-kmod-001_wext_workaround.patch"
    "wl-kmod-002_kernel_3.18_null_pointer.patch"
    "wl-kmod-003_gcc_4.9_remove_TIME_DATE_macros.patch"
    "wl-kmod-004_kernel_4.3_rdtscl_to_rdtsc.patch"
    "wl-kmod-005_kernel_4.7_IEEE80211_BAND_to_NL80211_BAND.patch"
    "wl-kmod-006_gcc_6_fix_indentation_warnings.patch"
    "wl-kmod-007_kernel_4.8_add_cfg80211_scan_info_struct.patch"
    "wl-kmod-008_fix_kernel_warnings.patch"
    "wl-kmod-009_kernel_4.11_remove_last_rx_in_net_device_struct.patch"
    "wl-kmod-010_kernel_4.12_add_cfg80211_roam_info_struct.patch"
    "wl-kmod-011_kernel_4.14_new_kernel_read_function_prototype.patch"
    "wl-kmod-012_kernel_4.15_new_timer.patch"
    "wl-kmod-013_gcc8_fix_bounds_check_warnings.patch"
    "wl-kmod-014_kernel_read_pos_increment_fix.patch"
    "wl-kmod-015_kernel_5.1_get_ds_removed.patch"
    "wl-kmod-016_fix_unsupported_mesh_point.patch"
    "wl-kmod-017_fix_gcc_fallthrough_warning.patch"
    "wl-kmod-018_kernel_5.6_adaptations.patch"
    "wl-kmod-019_kernel_5.9_segment_eq_removed.patch"
    "wl-kmod-020_kernel_5.10_get_set_fs_removed.patch"
    "wl-kmod-021_kernel_5.17_adaptation.patch"
    "wl-kmod-022_kernel_5.18_adaptation.patch"
    "wl-kmod-023_kernel_6.0_adaptation.patch"
    "wl-kmod-024_kernel_6.1_adaptation.patch"
    "wl-kmod-025_kernel_6.5_adaptation.patch"
    "wl-kmod-026_kernel_6.10_fix_empty_body_in_if_warning.patch"
    "wl-kmod-027_wpa_supplicant-2.11_add_max_scan_ie_len.patch"
  ];
in
stdenv.mkDerivation {
  name = "broadcom-sta-${version}-${kernel.version}";

  src = fetchurl {
    url = "https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/${tarball}";
    hash =
      hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = map (patch: "${rpmFusionPatches}/${patch}") patchset;

  makeFlags = [ "KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}" ];

  unpackPhase = ''
    runHook preUnpack
    sourceRoot=broadcom-sta
    mkdir "$sourceRoot"
    tar xvf "$src" -C "$sourceRoot"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    binDir="$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    docDir="$out/share/doc/broadcom-sta/"
    mkdir -p "$binDir" "$docDir"
    cp wl.ko "$binDir"
    cp lib/LICENSE.txt "$docDir"
    runHook postInstall
  '';

  meta = {
    description = "Kernel module driver for some Broadcom's wireless cards";
    homepage = "http://www.broadcom.com/support/802.11/linux_sta.php";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
