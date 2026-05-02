{
  mkKdeDerivation,
  fetchpatch,
  qttools,
  shared-mime-info,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kcoreaddons";

  patches = [
    # https://kde.org/info/security/advisory-20260427-1.txt
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/kcoreaddons/-/commit/6153c9ae025fa570174bb4a143df38fa2f46606b.diff";
      hash = "sha256-eFHEW7wEuOXClCAoBeo3lpmNcDg1YMwhBcr24pE6Urk=";
    })
  ];

  hasPythonBindings = true;

  extraNativeBuildInputs = [
    qttools
    shared-mime-info
  ];
  extraBuildInputs = [ qtdeclarative ];
}
