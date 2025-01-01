{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, fontconfig
, freetype
, libICE
, libSM
, libX11
, libXcursor
, libXfixes
, libXrandr
, libXrender
}:

stdenv.mkDerivation rec {
  pname = "segger-ozone";
  version = "3.30b";

  src = {
    x86_64-linux = fetchurl {
      url = "https://www.segger.com/downloads/jlink/Ozone_Linux_V${builtins.replaceStrings ["."] [""] version}_x86_64.tgz";
      hash = "sha256-W8Fo0q58pAn1aB92CjYARcN3vMLEguvsyozsS7VRArQ=";
    };
    i686-linux = fetchurl {
      url = "https://www.segger.com/downloads/jlink/Ozone_Linux_V${builtins.replaceStrings ["."] [""] version}_i386.tgz";
      hash = "sha256-Xq/69lwF2Ll5VdkYMDNRtc0YUUvWc+XR0FHJXxOLNQ4=";
    };
  }.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    fontconfig
    freetype
    libICE
    libSM
    libX11
    libXcursor
    libXfixes
    libXrandr
    libXrender
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv Lib lib
    mv * $out
    ln -s $out/Ozone $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "J-Link Debugger and Performance Analyzer";
    longDescription = ''
      Ozone is a cross-platform debugger and performance analyzer for J-Link
      and J-Trace.

        - Stand-alone graphical debugger
        - Debug output of any tool chain and IDE 1
        - C/C++ source level debugging and assembly instruction debugging
        - Debug information windows for any purpose: disassembly, memory,
          globals and locals, (live) watches, CPU and peripheral registers
        - Source editor to fix bugs immediately
        - High-speed programming of the application into the target
        - Direct use of J-Link built-in features (Unlimited Flash
          Breakpoints, Flash Download, Real Time Terminal, Instruction Trace)
        - Scriptable project files to set up everything automatically
          - New project wizard to ease the basic configuration of new projects

      1 Ozone has been tested with the output of the following compilers:
      GCC, Clang, ARM, IAR. Output of other compilers may be supported but is
      not guaranteed to be.
    '';
    homepage = "https://www.segger.com/products/development-tools/ozone-j-link-debugger";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ maintainers.bmilanov ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
