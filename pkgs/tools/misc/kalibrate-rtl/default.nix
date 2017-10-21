{ stdenv, fetchgit, autoreconfHook, pkgconfig, fftw, rtl-sdr, libusb1 }:

stdenv.mkDerivation rec {
  name = "kalibrate-rtl-20131214";

  # There are no tags/releases, so use the latest commit from git master.
  # Currently, the latest commit is from 2013-12-14.
  src = fetchgit {
    url = "https://github.com/steve-m/kalibrate-rtl.git";
    rev = "aae11c8a8dc79692a94ccfee39ba01e8c8c05d38";
    sha256 = "1spbfflkqnw9s8317ppsf7b1nnkicqsmaqsnz1zf8i49ix70i6kn";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ fftw rtl-sdr libusb1 ];

  meta = with stdenv.lib; {
    description = "Calculate local oscillator frequency offset in RTL-SDR devices";
    longDescription = ''
      Kalibrate, or kal, can scan for GSM base stations in a given frequency
      band and can use those GSM base stations to calculate the local
      oscillator frequency offset.

      This package is for RTL-SDR devices.
    '';
    homepage = https://github.com/steve-m/kalibrate-rtl;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
