{ stdenv, fetchurl, binutils-unwrapped, scons, gnum4, p7zip, glibc_multi, mesa
, xorg, libGLU, libGL, openal
, lib, makeWrapper, makeDesktopItem }:

let
  pname = "tdm";
  version = "2.07";

  desktop = makeDesktopItem {
    desktopName = pname;
    name = pname;
    exec = "@out@/bin/${pname}";
    icon = pname;
    terminal = "False";
    comment = "The Dark Mod - stealth FPS inspired by the Thief series";
    type = "Application";
    categories = "Game;";
    genericName = pname;
  };
in stdenv.mkDerivation {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "http://www.thedarkmod.com/sources/thedarkmod.${version}.src.7z";
    sha256 = "17wdpip8zvm2njz0xrf7xcxl73hnsc6i83zj18kn8rnjkpy50dd6";
  };
  nativeBuildInputs = [
    p7zip scons gnum4 makeWrapper
  ];
  buildInputs = [
    glibc_multi mesa.dev xorg.libX11.dev openal
    xorg.libXext.dev xorg.libXxf86vm.dev
    libGL libGLU
  ];
  unpackPhase = ''
    7z x $src
  '';

  # I'm pretty sure there's a better way to build 2 targets than a random hook
  preBuild = ''
    pushd tdm_update
    scons BUILD=release TARGET_ARCH=x64
    install -Dm755 tdm_update.linux $out/share/libexec/tdm_update.linux
    popd
  '';

  # why oh why can it find ld but not strip?
  postPatch = ''
    sed -i 's!strip \$!${binutils-unwrapped}/bin/strip $!' SConstruct
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 ${desktop}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop --subst-var out
    install -Dm755 thedarkmod.x64 $out/share/libexec/tdm

    # The package doesn't install assets, these get installed by running tdm_update.linux
    # Provide a script that runs tdm_update.linux on first launch
    install -Dm755 <(cat <<'EOF'
#!/bin/sh
set -e
DIR="$HOME/.local/share/tdm"
mkdir -p "$DIR"
cd "$DIR"
exec "PKGDIR/share/libexec/tdm_update.linux" --noselfupdate
EOF
    ) $out/bin/tdm_update

    install -Dm755 <(cat <<'EOF'
#!/bin/sh
set -e
DIR="$HOME/.local/share/tdm"
if [ ! -d "$DIR" ]; then
  echo "Please run tdm_update to (re)download game data"
else
  cd "$DIR"
  exec "PKGDIR/share/libexec/tdm"
fi
EOF
    ) $out/bin/tdm
    sed -i "s!PKGDIR!$out!g" $out/bin/tdm_update
    sed -i "s!PKGDIR!$out!g" $out/bin/tdm

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/tdm --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL libGLU ]}
  '';

  enableParallelBuilding = true;
  sconsFlags = [ "BUILD=release" "TARGET_ARCH=x64" ];
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";
  meta = with stdenv.lib; {
    description = "The Dark Mod - stealth FPS inspired by the Thief series";
    homepage = "http://www.thedarkmod.com";
    license = licenses.gpl3;
    maintainers = with maintainers; [ cizra ];
    platforms = with platforms; [ "x86_64-linux" ];  # tdm also supports x86, but I don't have a x86 install at hand to test.
  };
}
