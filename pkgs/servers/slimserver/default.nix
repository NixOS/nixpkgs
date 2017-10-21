{ stdenv, buildPerlPackage, fetchurl
, perl, perlPackages }:

buildPerlPackage rec {
  name = "slimserver-${version}";
  version = "7.9.0";

  src = fetchurl {
    url = "https://github.com/Logitech/slimserver/archive/${version}.tar.gz";
    sha256 = "07rhqipg7m28x0nqdd83nyzi88dp9cf8rr2pamdyrfcwyp1h1b44";
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
    # slimserver doesn't work with current DBIx/SQL versions, use bundled copies
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
  ";

  doCheck = false;

  installPhase = ''
    cp -r . $out
  '';

  outputs = [ "out" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Logitech/slimserver;
    description = "Server for Logitech Squeezebox players. This server is also called Logitech Media Server";
    # the firmware is not under a free license!
    # https://github.com/Logitech/slimserver/blob/public/7.9/License.txt
    license = licenses.unfree;
    maintainers = [ maintainers.phile314 ];
    platforms = platforms.linux;
  };
}
