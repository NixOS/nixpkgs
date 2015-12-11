{stdenv, fetchgit, bc, dtc}:

stdenv.mkDerivation rec {
  name = "uboot-odroid_xu4-${rev}";
  rev = "fa8883a1e39a20e72aaa5093af0c80062cb95757";
   
  src = fetchgit {
    url = "http://git.denx.de/u-boot.git";
    sha256 = "19l2dbav7hzw834qx8ihg9cq8ca3qak9aa4vsl05s5rhghj1iwmz";
    inherit rev;
  };

  patches = [ ./MAX_TFTP_PATH_LEN-increase.patch ];

  buildInputs = [ bc dtc ];

  # Remove the cross compiler prefix, and add reiserfs support
  configurePhase = ''
    make odroid-xu3_defconfig
    make u-boot-dtb.bin
  '';

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp u-boot-dtb.bin $out
  '';
}
