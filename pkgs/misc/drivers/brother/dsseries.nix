{ stdenv, requireFile, dpkg }:

stdenv.mkDerivation rec {
  version = "1.0.5-1";
  name = "brother-dsseries-${version}";
  supportSite = http://brother.com/;

  src =
    if stdenv.system == "x86_64-linux" then
      # 64-bit driver.
      requireFile {
        name = "libsane-dsseries_${version}_amd64.deb";
        url = supportSite;
        sha256 = "4e0b649df73f8e9900c045d5bbf7361fd32ca7e3dc18ca2723406fca66809927";
      }
    else if stdenv.system == "i686-linux" then
      # 32-bit driver.
      requireFile {
        name = "libsane-dsseries_${version}_i386.deb";
        url = supportSite;
        sha256 = "cff87d651750203d64c468fdb9b73cbf89d5a549568e066666bb0253a5bd512a";
      }
    else
      abort "brotherDSSeries requires i686-linux or x86_64 Linux";

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d $out/etc/sane.d/dll.d $out/lib/sane

    grep KERNEL usr/lib/tmp_DSDriver/50-Brother_DSScanner.rules \
      | sed -e 's/\r//' \
            -e 's/users/scanner/' \
            -e 's/$/, ENV{libsane_matched}="yes"/' \
        > $out/lib/udev/rules.d/50-Brother_DSScanner.rules

    cp usr/lib/tmp_DSDriver/dsseries.conf $out/etc/sane.d
    cp usr/lib/tmp_DSDriver/x64/dsdrv_x64.so $out/lib/sane
    cp usr/lib/tmp_DSDriver/x64/NvUSBScan_x64.so $out/lib/sane
    cp usr/lib/tmp_DSDriver/x64/libsane-dsseries.so.1.0.17 $out/lib/sane
    ln -s $out/lib/sane/libsane-dsseries.so.1.0.17 $out/lib/sane/libsane-dsseries.so.1
    ln -s $out/lib/sane/libsane-dsseries.so.1.0.17 $out/lib/sane/libsane-dsseries.so
    echo "dsseries" > $out/etc/sane.d/dll.d/dsseries.conf

    # This next part is a bit of a kludge.  The driver, when loaded,
    # tries to dlopen the other two .so files included in the deb
    # package.  But it does this using hard-coded absolute paths.
    # Using symbolic links and some sed magic we can trick the driver
    # into loading the other libraries from the nix store.
    ln -s $out/lib/sane/dsdrv_x64.so $out/lib/sane/_usr_lib_sane_dsdrv_x64.so
    ln -s $out/lib/sane/NvUSBScan_x64.so $out/lib/sane/_usr_lib_sane_NvUSBScan_x64.so

    for f in `find $out/lib -type f -name '*.so*'`; do
      sed -i "s|/usr/lib/sane/%s|_usr_lib_sane_%s|g" $f
      patchelf --set-rpath ${stdenv.cc.cc}/lib:$out/lib/sane $f
    done
  '';

  buildInputs = [ dpkg ];

  meta = with stdenv.lib; {
    description = "Bother DS Series Scanner Drivers for SANE";
    longDescription = ''
      Brother DS Series Scanner Drivers for SANE

      This package relies on a closed-source drvier from Brother.  You
      must download the driver file yourself (in deb format) and use

        nix-store --add-fixed sha256 <filename>

      or

        nix-prefetch-url file://path/to/file

      To use this driver on NixOS, place the following in your
      configuration.nix:

        hardware.sane.extraBackends = [ brotherDSSeries ];
    '';

    homepage = http://download.brother.com/;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pjones ];
  };
}
