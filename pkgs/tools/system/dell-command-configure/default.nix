{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "dell-command-configure";
  version = "4.2.0";

  src = fetchurl {
    url = "https://downloads.dell.com/FOLDER05519670M/1/command-configure_4.2.0-553.ubuntu16_amd64.tar.gz";
    sha256 = "0bwmrgz335sm1mfh890pjylcqg30q98vmgazcc4vc45sj13fvry1";
  };

  buildInputs = [ dpkg ];
  sourceRoot = pname;
  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    mkdir ${pname}
    tar -C ${pname} -xzf ${src}
    dpkg-deb -x ${pname}/command-configure_4.2.0-553.ubuntu16_amd64.deb ${pname}/command-configure
    dpkg-deb -x ${pname}/srvadmin-hapi_9.3.0_amd64.deb ${pname}/srvadmin-hapi
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib

    install -t $out/lib -m755 -v command-configure/opt/dell/dcc/libhapiintf.so
    install -t $out/bin -m755 -v command-configure/opt/dell/dcc/cctk
    install -t $out/bin -m755 -v srvadmin-hapi/opt/dell/srvadmin/sbin/dchcfg

    for lib in $(find srvadmin-hapi/opt/dell/srvadmin/lib64 -type l); do
        install -t $out/lib -m755 -v $lib
    done

    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib:$out/lib $out/lib/libhapiintf.so
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath ${stdenv.cc.cc.lib}/lib:$out/lib $out/bin/cctk
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/lib $out/bin/dchcfg
  '';

  meta = with stdenv.lib; {
    description = "Configure BIOS settings on Dell laptops.";
    homepage = "https://www.dell.com/support/article/us/en/19/sln311302/dell-command-configure";
    license = licenses.unfree;
    maintainers = with maintainers; [ maxeaubrey ];
    platforms = [ "x86_64-linux" ];
  };
}
