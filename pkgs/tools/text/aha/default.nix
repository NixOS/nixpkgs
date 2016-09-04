{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "aha-${version}";
  version = "0.4.9";

  src = fetchFromGitHub {
    sha256 = "0g7awnh7z4cj3kkmldg6kl8dsvdvs46vbf273crmpswk0r4hzj80";
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
