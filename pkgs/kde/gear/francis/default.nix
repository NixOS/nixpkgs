{
  mkKdeDerivation,
  fetchpatch,
  qtsvg,
  knotifications,
}:
mkKdeDerivation {
  pname = "francis";

  patches = [
    # Fix linking issue
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/utilities/francis/-/commit/4d5407a42e4871d66f4de4522fbbf83c35604550.patch";
      hash = "sha256-p9DVc92e8QBDHwZybVLNzSH8dr0XmRzrnIT45YD9t/Q=";
    })
  ];

  extraBuildInputs = [qtsvg knotifications];
}
