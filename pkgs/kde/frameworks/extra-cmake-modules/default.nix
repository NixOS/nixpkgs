{
  mkKdeDerivation,
  python3,
  qttools,
}:
mkKdeDerivation {
  pname = "extra-cmake-modules";

  # Don't depend on qdoc (leaks everywhere, causes random cross issues), we don't install the docs anyway
  # Upstream PR: https://invent.kde.org/frameworks/extra-cmake-modules/-/merge_requests/534
  patches = [ ./no-qdoc.patch ];

  outputs = [ "out" ];

  propagatedNativeBuildInputs = [
    # Packages that have an Android APK (e.g. KWeather) require Python3 at build time.
    # See: https://invent.kde.org/frameworks/extra-cmake-modules/-/blob/v6.1.0/modules/ECMAddAndroidApk.cmake?ref_type=tags#L57
    python3

    # Most packages require QDoc to generate docs, even if they're not installed
    (qttools.override { withClang = true; })
  ];

  setupHook = ./ecm-hook.sh;
}
