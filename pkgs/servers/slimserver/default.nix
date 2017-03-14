{ stdenv, fetchFromGitHub
, makeWrapper
#, sqlite, expat, mp4v2, flac, spidermonkey_1_8_5, taglib, libexif, curl, ffmpeg, file
, perl, perlPackages }:

stdenv.mkDerivation rec {
  name = "slimserver-${version}";
  version = "7.9";

  src = fetchFromGitHub {
    owner  = "Logitech";
    repo   = "slimserver";
    rev    = "095dd886a01e56a1ffe1b2ea31bb290d17c83948";
    sha256 = "06s945spxh6j4g0l1k6cxpq04011ad4swgqd2in87c86sf6bm445";
  };

  buildInputs = [
    makeWrapper
    perl
    perlPackages.AudioScan
    perlPackages.DBI
    perlPackages.DigestSHA1
    perlPackages.EV
    perlPackages.HTMLParser
    perlPackages.ImageScale
    # why do
    perlPackages.JSONXS
    perlPackages.JSONXSVersionOneAndTwo
    perlPackages.Log4Perl
    perlPackages.SubName
    perlPackages.XMLParser
    perlPackages.YAML
  ];

  buildPhase = ''
  '';

  installPhase = ''
    cp -r . $out
  '';
  
  postFixup = ''
    wrapProgram $out/slimserver.pl \
      --set PERL5LIB "${with perlPackages; stdenv.lib.makePerlPath [
      AudioScan
      DBI
      DigestSHA1
      EV
      HTMLParser
      ImageScale
      JSONXS
      JSONXSVersionOneAndTwo
      Log4Perl
      SubName
      XMLParser
      YAML
      ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Logitech/slimserver;
    description = "Server for Logitech Squeezebox players. This server is also called Logitech Media Server";
    # TODO: not all source code is under gpl2!
    license = licenses.gpl2;
    maintainers = [ maintainers.phile314 ];
    platforms = platforms.linux;
  };
}
