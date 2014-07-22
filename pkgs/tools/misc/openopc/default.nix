{ stdenv, fetchurl, pythonFull }:

stdenv.mkDerivation rec {
  name = "openopc-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/openopc/openopc/${version}/OpenOPC-${version}.source.tar.bz2";
    sha256 = "0mm77fiipz5zy82l6pr3wk18bfril81milv2rdxr954c4gw5smyd";
  };

  # There is no setup.py or any other "build system" file in the source archive.
  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/doc/openopc"
    mkdir -p "$out/${pythonFull.python.sitePackages}"
    mkdir -p "$out/libexec/opc"

    cp src/OpenOPC.py "$out/${pythonFull.python.sitePackages}"
    cp src/opc.py "$out/libexec/opc/"

    cat > "$out/bin/opc" << __EOF__
    #!${stdenv.shell}
    export PYTHONPATH="$out/${pythonFull.python.sitePackages}"
    exec ${pythonFull}/bin/${pythonFull.python.executable} "$out/libexec/opc/opc.py" "\$@"
    __EOF__
    chmod a+x "$out/bin/opc"

    cp -R *.txt doc/* "$out/share/doc/openopc/"

    # Copy these MS Windows tools, for reference.
    cp src/OpenOPCService.py src/SystemHealth.py "$out/libexec/opc/"
  '';

  meta = with stdenv.lib; {
    description = "OPC (OLE for Process Control) toolkit designed for use with Python";
    homepage = http://openopc.sourceforge.net/;
    # """OpenOPC for Python is freely available under the terms of the GNU GPL.
    # However, the OpenOPC library module is licensed under the "GPL + linking
    # exception" license, which generally means that programs written using the
    # OpenOPC library may be licensed under any terms."""
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
