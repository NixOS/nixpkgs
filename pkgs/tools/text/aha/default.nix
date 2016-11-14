{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "aha-${version}";
  version = "0.4.10.1";

  src = fetchFromGitHub {
    sha256 = "0j4jn8c0bhvbmpp2ynkw1y0l5dm49s7g5rmsvdxh0g1sjai161ss";
    rev = version;
    repo = "aha";
    owner = "theZiz";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "ANSI HTML Adapter";
    longDescription = ''
      aha takes ANSI SGR-coloured input and produces W3C-conformant HTML code.
    '';
    homepage = https://github.com/theZiz/aha;
    license = with licenses; [ lgpl2Plus mpl11 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
