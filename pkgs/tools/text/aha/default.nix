{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "aha-${version}";
  version = "0.4.10.2";

  src = fetchFromGitHub {
    sha256 = "14n0py8dzlvirawb8brq143nq0sy9s2z6in5589krrya0frlrlkj";
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
