{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "aha-${version}";
  version = "0.4.8";

  src = fetchFromGitHub {
    sha256 = "1209rda6kc9x88b47y1035zs9lxk0x3qzsb87f8m5b55fdkgxqlj";
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
