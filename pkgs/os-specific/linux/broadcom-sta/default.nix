{ stdenv, fetchurl, kernel }:

let version = "5_100_82_38";
    bits = if stdenv.system == "i686-linux" then "32" else
      assert stdenv.system == "x86_64-linux"; "64";
in

stdenv.mkDerivation {
  name = "broadcom-sta-${version}";
  src = fetchurl {
    url = "http://www.broadcom.com/docs/linux_sta/hybrid-portsrc_x86_${bits}-v${version}.tar.gz";
    sha256 = if bits == "32"
      then "0dzvnk0vmi5dlbsi9k2agvs5xsqn07mv66g9v1jzn1gsl8fsydpp"
      else "19rm9m949yqahgii7wr14lj451sd84s72mqj15yd0dnpm4k5n5hw";
  };

  buildInputs = [ kernel ];
  patches = [ ./makefile.patch ]
    ++ stdenv.lib.optional
    (! builtins.lessThan (builtins.compareVersions kernel.version "2.6.37") 0)
      [ ./mutex-sema.patch ];

  makeFlags = "KDIR=${kernel}/lib/modules/${kernel.version}/build";

  unpackPhase =
    ''
      sourceRoot=broadcom-sta
      mkdir "$sourceRoot"
      tar xvf "$src" -C "$sourceRoot"
    '';

  installPhase =
    ''
      binDir="$out/lib/modules/${kernel.version}/kernel/net/wireless/"
      docDir="$out/share/doc/broadcom-sta/"
      ensureDir "$binDir" "$docDir"
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
