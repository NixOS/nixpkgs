{
  mkKdeDerivation,
  fetchpatch,
  python3,
}:
mkKdeDerivation {
  pname = "extra-cmake-modules";

  outputs = [ "out" ];

  patches = [
    # Cherry-pick fix for not finding libmount include path correctly
    # Upstream PR: https://invent.kde.org/frameworks/extra-cmake-modules/-/merge_requests/486
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/extra-cmake-modules/-/commit/1cc17521fefd7adb0631d24a03497bcf63b9512d.patch";
      hash = "sha256-4NbhsVf14YuFHumbnXRgMcS3i/LZUDdrCWHrjHSjuo0=";
    })
  ];

  # Packages that have an Android APK (e.g. KWeather) require Python3 at build time.
  # See: https://invent.kde.org/frameworks/extra-cmake-modules/-/blob/v6.1.0/modules/ECMAddAndroidApk.cmake?ref_type=tags#L57
  propagatedNativeBuildInputs = [
    python3
  ];

  setupHook = ./ecm-hook.sh;
}
