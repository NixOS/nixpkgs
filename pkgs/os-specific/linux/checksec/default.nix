{ stdenv, fetchurl, file, findutils, binutils, glibc, procps, coreutils, sysctl }:

stdenv.mkDerivation rec {
  name = "checksec-${version}";
  version = "1.5";

  src = fetchurl {
    url    = "http://www.trapkit.de/tools/checksec.sh";
    sha256 = "0iq9v568mk7g7ksa1939g5f5sx7ffq8s8n2ncvphvlckjgysgf3p";
  };

  patches = [ ./0001-attempt-to-modprobe-config-before-checking-kernel.patch ];

  unpackPhase = ''
    mkdir ${name}
    cp $src ${name}/checksec.sh
    cd ${name}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp checksec.sh $out/bin/checksec
    chmod +x $out/bin/checksec
    substituteInPlace $out/bin/checksec --replace /bin/bash ${stdenv.shell}
    substituteInPlace $out/bin/checksec --replace /lib/libc.so.6 ${glibc.out}/lib/libc.so.6
    substituteInPlace $out/bin/checksec --replace find ${findutils}/bin/find
    substituteInPlace $out/bin/checksec --replace "file $" "${file}/bin/file $"
    substituteInPlace $out/bin/checksec --replace "xargs file" "xargs ${file}/bin/file"
    substituteInPlace $out/bin/checksec --replace " readelf -" " ${binutils.out}/bin/readelf -"
    substituteInPlace $out/bin/checksec --replace "(readelf -" "(${binutils.out}/bin/readelf -"
    substituteInPlace $out/bin/checksec --replace "command_exists readelf" "command_exists ${binutils.out}/bin/readelf"
    substituteInPlace $out/bin/checksec --replace "/sbin/sysctl -" "${sysctl}/bin/sysctl -"
    substituteInPlace $out/bin/checksec --replace "/usr/bin/id -" "${coreutils}/bin/id -"
  '';

  meta = {
    description = "A tool for checking security bits on executables";
    homepage    = "http://www.trapkit.de/tools/checksec.html";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
