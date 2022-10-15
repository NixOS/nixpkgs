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

stdenv.mkDerivation rec {
  pname = "gf";
  version = "unstable-2022-09-26";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "404fc6d66c60bb01e9bcbb69021e66c543bda2d5";
    hash = "sha256-HRejpEN/29Q+wukU3Jv3vZoK6/VjZK6VnZdvPuFBC9I=";
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
    description = "A GDB Frontend";
    homepage = "https://github.com/nakst/gf";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ _0xd61 ];
  };
}
