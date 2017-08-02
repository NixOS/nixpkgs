{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "ttylog-${version}";
  version = "0.29";

  src = fetchFromGitHub {
    owner = "rocasa";
    repo = "ttylog";
    rev = version;
    sha256 = "035i9slmdgds5azwxqwp6skxykvaq3mq4jckvm49fng8jq09z7zr";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = http://ttylog.sourceforg.net;
    description = "Simple serial port logger";
    longDescription = ''
      A serial port logger which can be used to print everything to stdout
      that comes from a serial device.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
