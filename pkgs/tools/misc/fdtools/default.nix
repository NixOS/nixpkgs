{ stdenv, lib, fetchurl, skawarePackages }:

let
  pname = "fdtools";
  version = "2020.05.04";
  sha256 = "0lnafcp4yipi0dl8gh33zjs8wlpz0mim8mwmiz9s49id0b0fmlla";

in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://code.dogmap.org/${pname}/releases/${pname}-${version}.tar.bz2";
    inherit sha256;
  };

  patches = [ ./new-skalibs.patch ];
  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  buildInputs = [ skawarePackages.skalibs ];

  configurePhase = ''
    cd ${pname}-${version}
    sed -e 's|gcc|$CC|' \
      conf-compile/defaults/host_link.sh \
      > conf-compile/host_link.sh
    sed -e 's|gcc|$CC|' \
      conf-compile/defaults/host_compile.sh \
      > conf-compile/host_compile.sh

    echo "${skawarePackages.skalibs.lib}/lib/skalibs/sysdeps" \
      > conf-compile/depend_skalibs_sysdeps
  '';

  buildPhase = ''
    bash package/build
  '';

  installPhase = ''
    mkdir -p $bin/bin
    tools=( grabconsole multitee pipecycle recvfd seek0 sendfd setblock setstate statfile vc-get vc-lock vc-switch )

    for t in "''${tools[@]}"; do
      mv "command/$t" "$bin/bin/$t"
    done

    mkdir -p $lib/lib
    mkdir -p $dev/include
    docdir=$doc/share/doc/${pname}
    mkdir -p $docdir

    mv library/fdtools.a $lib/lib/fdtools.a
    mv include/fdtools.h $dev/include/fdtools.h

    ${skawarePackages.cleanPackaging.commonFileActions {
       noiseFiles = [
         "conf-compile/**/*"
         "src/**/*"
         "src/.**/*"
         "compile/**/*"
         "package/{build,check,compile,elsewhere,install,install_commands,own,run,sharing,upgrade,upgrade_version,url_src,url_src_latest,versions}"
       ];
       docFiles = [
         "package/INSTALL"
         "package/LICENSE"
         "package/README"
       ];
    }} $docdir

    ${skawarePackages.cleanPackaging.checkForRemainingFiles}

    # we don’t use this, but nixpkgs requires it
    touch $out
  '';

  meta = {
    homepage = "https://code.dogmap.org./fdtools/";
    description = "A set of utilities for working with file descriptors";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.Profpatsch ];
  };
}
