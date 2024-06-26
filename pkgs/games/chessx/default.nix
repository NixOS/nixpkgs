{
  stdenv,
  lib,
  pkg-config,
  zlib,
  qtbase,
  qtsvg,
  qttools,
  qtmultimedia,
  qmake,
  fetchpatch,
  fetchurl,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chessx";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/chessx/chessx-${finalAttrs.version}.tgz";
    hash = "sha256-76YOe1WpB+vdEoEKGTHeaWJLpCVE4RoyYu1WLy3Dxhg=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qtsvg
    qttools
    zlib
  ];

  patches =
    # needed to backport patches to successfully build, due to broken release
    let
      repo = "https://github.com/Isarhamster/chessx/";
    in
    [
      (fetchpatch {
        url = "${repo}/commit/9797d46aa28804282bd58ce139b22492ab6881e6.diff";
        hash = "sha256-RnIf6bixvAvyp1CKuri5LhgYFqhDNiAVYWUmSUDMgVw=";
      })
      (fetchpatch {
        url = "${repo}/commit/4fab4d2f649d1cae2b54464c4e28337d1f20c214.diff";
        hash = "sha256-EJVHricN+6uabKLfn77t8c7JjO7tMmZGsj7ZyQUGcXA=";
      })
    ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 release/chessx -t "$out/bin"
    install -Dm444 unix/chessx.desktop -t "$out/share/applications"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://chessx.sourceforge.io/";
    description = "Browse and analyse chess games";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      eclairevoyant
      luispedro
    ];
    platforms = platforms.linux;
    mainProgram = "chessx";
  };
})
