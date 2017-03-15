{ stdenv, buildPerlPackage, fetchFromGitHub
#, sqlite, expat, mp4v2, flac, spidermonkey_1_8_5, taglib, libexif, curl, ffmpeg, file
, perl, perlPackages }:

buildPerlPackage rec {
  name = "slimserver-${version}";
  version = "7.9";

  src = fetchFromGitHub {
    owner  = "Logitech";
    repo   = "slimserver";
    rev    = "095dd886a01e56a1ffe1b2ea31bb290d17c83948";
    sha256 = "06s945spxh6j4g0l1k6cxpq04011ad4swgqd2in87c86sf6bm445";
  };

  buildInputs = [
    perl
    perlPackages.AnyEvent
    perlPackages.AudioScan
    perlPackages.CarpClan
    perlPackages.CGI
    perlPackages.ClassXSAccessor
    perlPackages.DataDump
    perlPackages.DataURIEncode
    perlPackages.DBDSQLite
    perlPackages.DBI
    perlPackages.DBIxClass
    perlPackages.DigestSHA1
    perlPackages.EV
    perlPackages.ExporterLite
    perlPackages.FileBOM
    perlPackages.FileCopyRecursive
    perlPackages.FileNext
    perlPackages.FileReadBackwards
    perlPackages.FileSlurp
    perlPackages.FileWhich
    perlPackages.HTMLParser
    perlPackages.HTTPCookies
    perlPackages.HTTPDaemon
    perlPackages.HTTPMessage
    perlPackages.ImageScale
    perlPackages.IOSocketSSL
    perlPackages.IOString
    perlPackages.JSONXSVersionOneAndTwo
    perlPackages.Log4Perl
    perlPackages.LWPUserAgent
    perlPackages.NetHTTP
    perlPackages.ProcBackground
    perlPackages.SubName
    perlPackages.TemplateToolkit
    perlPackages.TextUnidecode
    perlPackages.TieCacheLRU
    perlPackages.TieCacheLRUExpires
    perlPackages.TieRegexpHash
    perlPackages.TimeDate
    perlPackages.URI
    perlPackages.URIFind
    perlPackages.UUIDTiny
    perlPackages.XMLParser
    perlPackages.XMLSimple
    perlPackages.YAMLLibYAML
  ];


  prePatch = ''
    mkdir CPAN_used
    mv CPAN/DBIx CPAN/SQL CPAN_used
    rm -rf CPAN
    rm -rf Bin
    touch Makefile.PL
    '';

  preConfigurePhase = "";

  buildPhase = "
    mv lib tmp
    mkdir -p lib/perl5/site_perl
    mv CPAN_used/* lib/perl5/site_perl
    cp -rf tmp/* lib/perl5/site_perl
    mv Slim lib/perl5/site_perl
  ";

  doCheck = false;

  installPhase = ''
    cp -r . $out
  '';

  outputs = [ "out" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Logitech/slimserver;
    description = "Server for Logitech Squeezebox players. This server is also called Logitech Media Server";
    # TODO: not all source code is under gpl2!
    license = licenses.gpl2;
    maintainers = [ maintainers.phile314 ];
    platforms = platforms.linux;
  };
}
