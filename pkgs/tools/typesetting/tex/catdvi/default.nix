{ stdenv
, lib
, fetchurl
, fetchpatch
, texlive
, buildPackages
}:

let
  buildPlatformTools = [ "pse2unic" "adobe2h" ];
  tex = texlive.combine {
    inherit (texlive) collection-fontsrecommended;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "catdvi";
  version = "0.14";
  src = fetchurl {
    url = with finalAttrs; "http://downloads.sourceforge.net/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-orVQVdQuRXp//OGkA7xRidNi4+J+tkw398LPZ+HX+k8=";
  };

  patches = [
    # fix error: conflicting types for 'kpathsea_version_string'; have 'char *'
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/catdvi/0.14-14/debian/patches/03_kpathsea_version_string_declaration.diff";
      hash = "sha256-d3CPDxXdVVLNtKkN0rC2G02dh/bJrRll/nVzQNggwkk=";
    })
  ];

  hardeningDisable = [ "format" ];

  outputs = [ "out" ] ++ lib.optional (with stdenv; buildPlatform.canExecute hostPlatform) "dev";

  setOutputFlags = false;

  enableParallelBuilding = true;

  preBuild = lib.optionalString (with stdenv; !buildPlatform.canExecute hostPlatform)
    (lib.concatMapStringsSep "\n" (tool: ''
      cp ${lib.getDev buildPackages.catdvi}/bin/${tool} .
    '') buildPlatformTools);

  nativeBuildInputs = [
    texlive.bin.core
    texlive.bin.core.dev
  ];

  buildInputs = [
    tex
  ];

  makeFlags = [
    "catdvi"  # to avoid running tests until checkPhase
  ] ++ lib.optionals (with stdenv; !buildPlatform.canExecute hostPlatform)
    (map (tool: "--assume-old=${tool}") buildPlatformTools);

  nativeCheckInputs = [
    texlive
  ];

  testFlags = [
    "all1"
  ];

  preInstall = ''
    mkdir -p $out/{bin,man/man1}
  '';

  postInstall = lib.optionalString (with stdenv; buildPlatform.canExecute hostPlatform) ''
    mkdir -p $dev/bin
    ${lib.concatMapStringsSep "\n" (tool: ''
      cp ${tool} $dev/bin/
    '') buildPlatformTools}
  '' + ''
    mkdir -p $out/share
    ln -s ${tex}/share/texmf-var $out/share/texmf
  '';

  meta = with lib; {
    homepage = "http://catdvi.sourceforge.net";
    description = "A DVI to plain text translator";
    license = licenses.gpl2;
    maintainers = [ ];
  };
})
