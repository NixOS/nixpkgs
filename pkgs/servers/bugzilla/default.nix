{ stdenv, pkgs, fetchurl, perlPackages }:

stdenv.mkDerivation rec {

    name = "bugzilla-5.1.1";

    src = fetchurl {
        url = "https://ftp.mozilla.org/pub/webtools/${name}.tar.gz";
        sha256 = "2d18aec033e33222ef70f2ae6e17ffd59240bd4c322e2c29e88f8759eb9a343b";
    };

    propagatedBuildInputs = with perlPackages; [ DateTime TimeDate Chart
                                       EmailMIME EmailSender GD GDGraph GDText SOAPLite
                                       NetLDAP TemplateToolkit MathRandomISAAC
                                       PatchReader TemplateGD DBI FileSlurp CGI PatchReader
                                       JSONXS AuthenRadius NetLDAP EncodeDetect FileCopyRecursive
                                       FileWhich HTMLScrubber EmailReply HTMLFormatTextWithLinks
                                       TextMarkdown CacheMemcachedFast MIMETools XMLTwig
                                       DBDmysql DBDPg DBDSQLite AuthenSASL NetSMTPSSL
                                       FileMimeInfo perl
    ];

    configurePhase = ''
        perl checksetup.pl
    '';

    installPhase = ''
      find . -type d -name CVS -exec rm -rf {} \; || true
      find . -type f -name .cvsignore -exec rm -f {} \; || true
      rm -rf .bzr
      rm -rf .bzrrev
      rm -rf .bzrignore
      rm -rf .git
      rm -rf .gitignore

      install -d -m0755 $out/var/www/html/bugzilla
      cp -a ../${name} $out/var/www/html/bugzilla
    '';
}
