{ stdenv, fetchurl, kernel }:

let version = "5.60.246.6";
    bits = if stdenv.system == "i686-linux" then "32" else
      assert stdenv.system == "x86_64-linux"; "64";
in

stdenv.mkDerivation {
  name = "broadcom-sta-${version}";
  src = fetchurl {
    url = "http://www.broadcom.com/docs/linux_sta/hybrid-portsrc_x86-${bits}_v${version}.tar.gz";
    sha256 = if bits == "32"
      then "0y8ap9zhfsg1k603qf5a7n73zvsw7nkqh42dlcyxan5zdzmgcqdx"
      else "0z8a57fpajiag830g1ifc9vrm7wk5bm7dwi7a9ljm3cns3an07fl";
  };

  buildInputs = [ kernel ];
  patches = [ ./makefile.patch ];

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
