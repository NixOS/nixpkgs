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
  version = "unstable-2022-06-22";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "e0d6d2f59344f853a4a204d5313db6b6a5e5de7d";
    sha256 = "01fln4wnn1caqr4wa1nhcp0rqdx5m5nqyn2amvclp5hhi3h3qaiq";
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
