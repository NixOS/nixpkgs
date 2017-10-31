{ stdenv, kernel }:

stdenv.mkDerivation rec {
  inherit (kernel) version src;

  name = "freefall-${version}";

  postPatch = ''
    cd tools/laptop/freefall

    # Default time-out is a little low, probably because the AC/lid status
    # functions were never implemented. Because no-one still uses HDDs, right?
    substituteInPlace freefall.c --replace "alarm(2)" "alarm(5)"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    inherit (kernel.meta) homepage license;

    description = "Free-fall protection for spinning HP/Dell laptop hard drives";
    longDescription = ''
      Provides a shock protection facility in modern laptops with spinning hard
      drives, by stopping all input/output operations on the internal hard drive
      and parking its heads on the ramp when critical situations are anticipated.
      Requires support for the ATA/ATAPI-7 IDLE IMMEDIATE command with unload
      feature, which should cause the drive to switch to idle mode and unload the
      disk heads, and an accelerometer device. It has no effect on SSD devices!
    '';

    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
