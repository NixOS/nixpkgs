{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "aha";
  version = "0.5";

  src = fetchFromGitHub {
    sha256 = "0byml4rmpiaalwx69jcixl3yvpvwmwiss1jzgsqwshilb2p4qnmz";
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
    homepage = "https://github.com/theZiz/aha";
    license = with licenses; [ lgpl2Plus mpl11 ];
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
