{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.18.3";
  name = "freefall-${version}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0ma2x68975xsi9kb15p0615nx9sm5ppb309kfdz7fgx9pg84q0hf";
  };

  buildPhase = ''
    cd Documentation/laptops

    # Default time-out is a little low, probably because the AC/lid status
    # functions were never implemented. Because no-one still uses HDDs, right?
    substituteInPlace freefall.c --replace "alarm(2)" "alarm(5)"

    cc -o freefall freefall.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    install freefall $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Free-fall protection for spinning HP/Dell laptop hard drives";
    longDescription = ''
      ATA/ATAPI-7 specifies the IDLE IMMEDIATE command with unload feature.
      Issuing this command should cause the drive to switch to idle mode and
      unload disk heads. This feature is being used in modern laptops in
      conjunction with accelerometers and appropriate software to implement
      a shock protection facility. The idea is to stop all I/O operations on
      the internal hard drive and park its heads on the ramp when critical
      situations are anticipated. This has no effect on SSD devices!
    '';
    license = with licenses; gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
