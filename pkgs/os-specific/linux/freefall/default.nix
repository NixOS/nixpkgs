{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "freefall-${version}";
  version = "4.3";

  src = fetchurl {
    sha256 = "1bpkr45i4yzp32p0vpnz8mlv9lk4q2q9awf1kg9khg4a9g42qqja";
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
  };

  postPatch = ''
    cd tools/laptop/freefall

    # Default time-out is a little low, probably because the AC/lid status
    # functions were never implemented. Because no-one still uses HDDs, right?
    substituteInPlace freefall.c --replace "alarm(2)" "alarm(5)"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Free-fall protection for spinning HP/Dell laptop hard drives";
    longDescription = ''
      Provides a shock protection facility in modern laptops with spinning hard
      drives, by stopping all input/output operations on the internal hard drive
      and parking its heads on the ramp when critical situations are anticipated.
      Requires support for the ATA/ATAPI-7 IDLE IMMEDIATE command with unload
      feature, which should cause the drive to switch to idle mode and unload the
      disk heads, and an accelerometer device. It has no effect on SSD devices!
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
