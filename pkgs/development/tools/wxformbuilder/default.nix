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
  version = "unstable-2023-04-21";

  src = fetchFromGitHub {
    owner = "wxFormBuilder";
    repo = "wxFormBuilder";
    rev = "f026a8e1a7f68e794638f637e53845f8f04869ef";
    fetchSubmodules = true;
    hash = "sha256-48J8osSBb5x9b8MYWZ5QGF6rWgwtcJ0PLLAYViDr50M=";
  };

  postPatch = ''
    substituteInPlace .git-properties \
      --replace "\$Format:%h\$" "${builtins.substring 0 7 finalAttrs.src.rev}" \
      --replace "\$Format:%(describe)\$" "${builtins.substring 0 7 finalAttrs.src.rev}"
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
