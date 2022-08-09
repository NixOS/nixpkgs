{ lib
, fetchsvn
, stdenv
, libopus
, xorg
, pname
, releaseFile ? pname
, buildFlags
, buildInputs
, nativeBuildInputs ? []
, postFixup ? ""
, description
, ... }:

stdenv.mkDerivation {
  inherit pname buildFlags buildInputs nativeBuildInputs postFixup;
  version = "unstable-2022-08-09";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/fteqw/code/trunk";
    rev = "6303";
    sha256 = "sha256-tSTFX59iVUvndPRdREayKpkQ+YCYKCMQe2PXZfnTgPQ=";
  };

  makeFlags = [
    "PKGCONFIG=$(PKG_CONFIG)"
    "-C" "engine"
  ];

  enableParallelBuilding = true;
  postPatch = ''
    substituteInPlace ./engine/Makefile \
      --replace "I/usr/include/opus" "I${libopus.dev}/include/opus"
    substituteInPlace ./engine/gl/gl_vidlinuxglx.c \
      --replace 'Sys_LoadLibrary("libXrandr"' 'Sys_LoadLibrary("${xorg.libXrandr}/lib/libXrandr.so"'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 engine/release/${releaseFile} $out/bin/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    inherit description;
    homepage = "https://fte.triptohell.info";
    longDescription = ''
      FTE is a game engine baed on QuakeWorld able to
      play games such as Quake 1, 2, 3, and Hexen 2.
      It includes various features such as extended map
      limits, vulkan and OpenGL renderers, a dedicated
      server, and fteqcc, for easier QuakeC development
    '';
    maintainers = with maintainers; [ necrophcodr ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
