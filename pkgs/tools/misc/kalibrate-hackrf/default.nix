{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, fftw, hackrf, libusb1 }:

stdenv.mkDerivation rec {
  name = "kalibrate-hackrf-unstable-20160827";

  # There are no tags/releases, so use the latest commit from git master.
  # Currently, the latest commit is from 2016-07-03.
  src = fetchFromGitHub {
    owner = "scateu";
    repo = "kalibrate-hackrf";
    rev = "2492c20822ca6a49dce97967caf394b1d4b2c43e";
    sha256 = "1jvn1qx7csgycxpx1k804sm9gk5a0c65z9gh8ybp9awq3pziv0nx";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ fftw hackrf libusb1 ];

  postInstall = ''
    mv $out/bin/kal $out/bin/kal-hackrf
  '';

  meta = with stdenv.lib; {
    description = "Calculate local oscillator frequency offset in hackrf devices";
    longDescription = ''
      Kalibrate, or kal, can scan for GSM base stations in a given frequency
      band and can use those GSM base stations to calculate the local
      oscillator frequency offset.

      This package is for hackrf devices.
    '';
    homepage = https://github.com/scateu/kalibrate-hackrf;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.mog ];
  };
}
