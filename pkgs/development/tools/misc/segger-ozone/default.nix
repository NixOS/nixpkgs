{ stdenv
, fetchurl
, fontconfig
, freetype
, lib
, libICE
, libSM
, udev
, libX11
, libXcursor
, libXext
, libXfixes
, libXrandr
, libXrender
}:

stdenv.mkDerivation rec {
  pname = "segger-ozone";
  version = "3.22a";

  src = fetchurl {
    url = "https://www.segger.com/downloads/jlink/Ozone_Linux_V${(lib.replaceStrings ["."] [""] version)}_x86_64.tgz";
    sha256 = "0v1r8qvp1w2f3yip9fys004pa0smlmq69p7w77lfvghs1rmg1649";
  };

  rpath = lib.makeLibraryPath [
    fontconfig
    freetype
    libICE
    libSM
    udev
    libX11
    libXcursor
    libXext
    libXfixes
    libXrandr
    libXrender
  ]
  + ":${stdenv.cc.cc.lib}/lib64";

  installPhase = ''
    mkdir -p $out/bin
    mv Lib lib
    mv * $out
    ln -s $out/Ozone $out/bin
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/Ozone" \
      --set-rpath ${rpath}:$out/lib "$out/Ozone"

    for file in $(find $out/lib -maxdepth 1 -type f -and -name \*.so\*); do
      patchelf --set-rpath ${rpath}:$out/lib $file
    done
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
    platforms = [ "x86_64-linux" ];
  };
}
