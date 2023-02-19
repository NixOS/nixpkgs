{ lib
, stdenv
, fetchurl
, fetchFromGitLab
, buildPythonPackage
, pkg-config
, glib
, meson
, ninja
, isPy3k
, pugixml
, fmt
, html-tidy
, pybind11
, python
}:

buildPythonPackage rec {
  pname = "syndom";
  version = "1.0";

  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    owner = "gabmus";
    repo = "syndication-domination";
    rev = version;
    sha256 = "sha256-IABeXK8fUMSFG8y5c3lZS68TO+Ui3CaOoXJ6HKWaOJ0=";
  };

  # Python 2.x is not supported.
  disabled = !isPy3k;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    pugixml
    fmt
    html-tidy
    pybind11
  ];
}
