{ lib
, stdenv
, makeWrapper
, fetchFromGitHub
, libX11
, pkg-config
, gdb
, freetype
, freetypeSupport ? true
, extensions ? [ ]
}:

stdenv.mkDerivation {
  pname = "gf";
  version = "unstable-2023-08-09";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "4190211d63c1e5378a9e841d22fa2b96a1099e68";
    hash = "sha256-28Xgw/KxwZ94r/TXsdISeUtXHSips4irB0D+tEefMYE=";
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];
  buildInputs = [ libX11 gdb ]
    ++ lib.optional freetypeSupport freetype;

  patches = [
    ./build-use-optional-freetype-with-pkg-config.patch
  ];

  postPatch = lib.forEach extensions (ext: ''
      cp ${ext} ./${ext.name or (builtins.baseNameOf ext)}
  '');

   preConfigure = ''
     patchShebangs build.sh
   '';

  buildPhase = ''
    runHook preBuild
    extra_flags=-DUI_FREETYPE_SUBPIXEL ./build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp gf2 "$out/bin/"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/gf2 --prefix PATH : ${lib.makeBinPath[ gdb ]}
  '';

  meta = with lib; {
    description = "GDB Frontend";
    homepage = "https://github.com/nakst/gf";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "gf2";
    maintainers = with maintainers; [ _0xd61 ];
  };
}
