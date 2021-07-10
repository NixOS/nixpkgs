{stdenv, fetchurl, dpkg, bash, glibc, libglvnd, zlib, glib, xorg, libxkbcommon, fontconfig, freetype, dbus}:

let
  rpath = stdenv.lib.makeLibraryPath [
    zlib libglvnd glib dbus fontconfig freetype
    xorg.libX11 xorg.libxcb xorg.libXrender xorg.libXext libxkbcommon
  ] + ":${stdenv.cc.cc.lib}/lib";
in stdenv.mkDerivation rec {
  pname = "intel-gpa";
  version = "20.1.1585397060";

  src = fetchurl {
    url = "https://software.intel.com/sites/products/gpa/downloads/linux/gpa_${version}_release_m64_deb_install.sh";
    sha256 ="0w56w0l7n63qp4jq65ij41nhdlvxil2n2yg4gisw71yhshlw81fm";
  };

  unpackPhase = ''
    LINE_NUMBER=$(grep --text --line-number '^PAYLOAD:$' $src | cut -d ':' -f 1)
    tail -n +$((LINE_NUMBER + 1)) $src | ${dpkg}/bin/dpkg-deb -x - .
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out"
    mv usr/share "$out"
    ln -s "$out/opt/intel/gpa/FrameAnalyzer" "$out/bin/gpa-frame-analyzer"
    ln -s "$out/opt/intel/gpa/SystemAnalyzer" "$out/bin/gpa-system-analyzer"
    ln -s "$out/opt/intel/gpa/gpa_console_client" "$out/bin/gpa-console-client"
    ln -s "$out/opt/intel/gpa/TraceAnalyzer" "$out/bin/gpa-trace-analyzer"
    ln -s "$out/opt/intel/gpa/GpaMonitor" "$out/bin/gpa-monitor"
  '';

  preFixup = ''
    substituteInPlace "$out/opt/intel/gpa/FrameAnalyzer.sh" --replace '#!/bin/sh' '#!${bash}/bin/sh'
    rpath="${rpath}:$out/opt/intel/gpa/python3/lib:$out/opt/intel/gpa"
    for binary in GpaMonitor GpaRemotePlayer GpaServer GpaPlayer FrameAnalyzer SystemAnalyzer gpa_console_client TraceAnalyzer; do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/opt/intel/gpa/$binary"
        patchelf --set-rpath "$rpath" "$out/opt/intel/gpa/$binary"
    done
    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
        patchelf --set-rpath "$rpath" "$lib"
    done
  '';

  meta = with stdenv.lib; {
    description = "Intel Graphics Performance Analyzers";
    homepage = "https://software.intel.com/content/www/us/en/develop/tools/graphics-performance-analyzers.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ ralith ];
    platforms = platforms.linux;
  };
}
