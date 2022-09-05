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
  version = "unstable-2022-08-01";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "c0a018a9b965eb97551ee87d5236a9f57011cea2";
    hash = "sha256-i0aLSy+4/fbYZpUKExFDUZ/2nXJmEhRsAX0JQZ8EhNk=";
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
