{
  lib,
  stdenv,
  fetchurl,
  cpio,
  e2fsprogs,
  perl,
  pkg-config,
  ocamlPackages,
  glibc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "supermin";
<<<<<<< HEAD
  version = "5.3.5";

  src = fetchurl {
    url = "https://download.libguestfs.org/supermin/${lib.versions.majorMinor finalAttrs.version}-development/supermin-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-0oLIHccG7+pGZIGhOfmwso0sHqagofV912GmvBG5nOI=";
=======
  version = "5.2.2";

  src = fetchurl {
    url = "https://download.libguestfs.org/supermin/${lib.versions.majorMinor finalAttrs.version}-stable/supermin-${finalAttrs.version}.tar.gz";
    sha256 = "zjkh02NcgWjPt8oMWoK51c71srJx+Et3bWO4u77sNY4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cpio
    e2fsprogs
    perl
    pkg-config
  ]
  ++ (with ocamlPackages; [
    findlib
    ocaml
  ]);
  buildInputs = lib.optionals stdenv.hostPlatform.isGnu [
    glibc
    glibc.static
  ];

  postPatch = ''
    patchShebangs src/bin2c.pl
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://libguestfs.org/supermin.1.html";
    description = "Tool for creating and building supermin appliances";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://libguestfs.org/supermin.1.html";
    description = "Tool for creating and building supermin appliances";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "supermin";
  };
})
