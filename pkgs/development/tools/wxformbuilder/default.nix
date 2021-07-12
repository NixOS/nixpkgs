{ lib, stdenv
, fetchFromGitHub
, wxGTK31
, meson
, ninja
}:

stdenv.mkDerivation {
  pname = "wxFormBuilder";
  version = "unstable-2020-08-18";

  src = fetchFromGitHub {
    owner = "wxFormBuilder";
    repo = "wxFormBuilder";
    rev = "d053665cc33a79dd935b518b5e7aea6baf493c92";
    sha256 = "sha256-hTO7Fyp5ZWpq2CfIYEXB85oOkNrqr6Njfh8h0t9B6wU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ninja
    meson
  ];

  buildInputs = [
    wxGTK31
  ];

  meta = with lib; {
    description = "RAD tool for wxWidgets GUI design";
    homepage = "https://github.com/wxFormBuilder/wxFormBuilder";
    license = licenses.gpl2;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
