{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "aha-${version}";
  version = "0.4.10.6";

  src = fetchFromGitHub {
    sha256 = "18mz3f5aqw4vbdrxf8wblqm6nca73ppq9hb2z2ppw6k0557i71kz";
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
