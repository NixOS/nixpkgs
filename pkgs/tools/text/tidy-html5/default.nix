{ stdenv, lib, cmake, fetchFromGitHub, libxslt, ... }:

stdenv.mkDerivation rec {

  name = "tidy-html5";
  version = "4.9.30";

  src = fetchFromGitHub {
    owner = "htacg";
    repo = "tidy-html5";
    rev = version;
    sha256 = "0hd4c23352r5lnh23mx137wb4mkxcjdrl1dy8kgghszik5fprs3s";
  };

  buildInputs = [ cmake libxslt ];

  meta = with stdenv.lib; {
    description = "The granddaddy of HTML tools, with support for modern standards";
    homepage = "http://www.html-tidy.org/";
    license = licenses.w3c;
    platforms = platforms.all;
    maintainers = with maintainers; [ edwtjo ];
  };

}
