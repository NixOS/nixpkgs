{ lib
, stdenv
, fetchFromGitHub
, cmake
, makeWrapper
, shared-mime-info
, wxGTK32
, boost
, Cocoa
}:

stdenv.mkDerivation {
  pname = "wxFormBuilder";
  version = "unstable-2022-09-26";

  src = fetchFromGitHub {
    owner = "wxFormBuilder";
    repo = "wxFormBuilder";
    rev = "e2e4764f1f4961c654733287c6e84d7738b4ba2b";
    fetchSubmodules = true;
    sha256 = "sha256-DLdwQH3s/ZNVq+A/qtZRy7dA/Ctp2qkOmi6M+rSb4MM=";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals stdenv.isDarwin [
    makeWrapper
  ] ++ lib.optionals stdenv.isLinux [
    shared-mime-info
  ];

  buildInputs = [
    wxGTK32
    boost
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  preConfigure = ''
    sed -i 's/FATAL_ERROR/WARNING/' cmake/revision-git*.cmake
    sed -i '/fixup_bundle/d;/codesign/d' cmake/macros.cmake
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/wxFormBuilder.app $out/Applications
    makeWrapper $out/{Applications/wxFormBuilder.app/Contents/MacOS,bin}/wxFormBuilder
  '';

  meta = with lib; {
    description = "RAD tool for wxWidgets GUI design";
    homepage = "https://github.com/wxFormBuilder/wxFormBuilder";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthuszagh wegank ];
  };
}
