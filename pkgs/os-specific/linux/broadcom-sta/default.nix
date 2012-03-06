{ stdenv, fetchurl, kernel }:

let version = "5_100_82_112";
    bits = if stdenv.system == "i686-linux" then "32" else
      assert stdenv.system == "x86_64-linux"; "64";
in

stdenv.mkDerivation {
  name = "broadcom-sta-${version}-${kernel.version}";
  
  src = fetchurl {
    url = "http://www.broadcom.com/docs/linux_sta/hybrid-portsrc_x86_${bits}-v${version}.tar.gz";
    sha256 = if bits == "32"
      then "1rvhw9ngw0djxyyjx5m01c0js89zs3xiwmra03al6f9q7cbf7d45"
      else "1qsarnry10f5m8a73wbr9cg2ifs00sqg6x0ay59l72vl9hb2zlww";
  };

  buildInputs = [ kernel ];
  patches = [ ./makefile.patch ./linux-2.6.39.patch ./linux-3.2.patch ];
    #++ stdenv.lib.optional
    #(! builtins.lessThan (builtins.compareVersions kernel.version "2.6.37") 0)
      #[ ./mutex-sema.patch ];

  makeFlags = "KDIR=${kernel}/lib/modules/${kernel.modDirVersion}/build";

  unpackPhase =
    ''
      sourceRoot=broadcom-sta
      mkdir "$sourceRoot"
      tar xvf "$src" -C "$sourceRoot"
    '';

  installPhase =
    ''
      binDir="$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
      docDir="$out/share/doc/broadcom-sta/"
      mkdir -p "$binDir" "$docDir"
      cp wl.ko "$binDir"
      cp lib/LICENSE.txt "$docDir"
    '';

  meta = {
    description = "Kernel module driver for some Broadcom's wireless cards";
    homepage = http://www.broadcom.com/support/802.11/linux_sta.php;
    license = "unfree-redistributable";
    maintainers = [ stdenv.lib.maintainers.neznalek ];
    platforms = stdenv.lib.platforms.linux;
  };
}
