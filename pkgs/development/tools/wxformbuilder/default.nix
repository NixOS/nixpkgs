{ lib
, stdenv
, fetchFromGitHub
, cmake
, darwin
, makeWrapper
, shared-mime-info
, boost
, wxGTK32
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxformbuilder";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "wxFormBuilder";
    repo = "wxFormBuilder";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      substituteInPlace $out/.git-properties \
        --replace "\$Format:%h\$" "$(git -C $out rev-parse --short HEAD)" \
        --replace "\$Format:%(describe)\$" "$(git -C $out rev-parse --short HEAD)"
      rm -rf $out/.git
    '';
    hash = "sha256-Lqta+u9WVwUREsR7aH+2DJn0oM5QwlwRSBImuwNkmS4=";
  };

  postPatch = ''
    substituteInPlace third_party/tinyxml2/cmake/tinyxml2.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    sed -i '/fixup_bundle/d' cmake/macros.cmake
  '';

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.sigtool
    makeWrapper
  ] ++ lib.optionals stdenv.isLinux [
    shared-mime-info
  ];

  buildInputs = [
    boost
    wxGTK32
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
  ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/wxFormBuilder.app $out/Applications
    makeWrapper $out/Applications/wxFormBuilder.app/Contents/MacOS/wxFormBuilder $out/bin/wxformbuilder
  '';

  meta = with lib; {
    description = "RAD tool for wxWidgets GUI design";
    homepage = "https://github.com/wxFormBuilder/wxFormBuilder";
    license = licenses.gpl2Only;
    mainProgram = "wxformbuilder";
    maintainers = with maintainers; [ matthuszagh wegank ];
    platforms = platforms.unix;
  };
})
