{ stdenv, fetchurl, perlPackages }:

perlPackages.buildPerlPackage rec {
  name = "foswiki-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/foswiki/${version}/Foswiki-${version}.tgz";
    sha256 = "03286pb966h99zgickm2f20rgnqwp9wga5wfkdvirv084kjdh8vp";
  };

  outputs = [ "out" ];

  buildInputs = with perlPackages; [
    # minimum requirements from INSTALL.html#System_Requirements
    AlgorithmDiff ArchiveTar AuthenSASL CGI CGISession CryptPasswdMD5
    EmailMIME Encode Error FileCopyRecursive HTMLParser HTMLTree
    IOSocketSSL JSON
    LocaleMaketextLexicon LocaleMsgfmt
    LWP URI perlPackages.version
    /*# optional dependencies
    libapreq2 DBI DBDmysql DBDPg DBDSQLite FCGI FCGIProcManager
    CryptSMIME CryptX509 ConvertPEM
    */
  ];

  preConfigure = ''
    touch Makefile.PL
    patchShebangs .
  '';
  configureScript = "bin/configure";

  # there's even no makefile
  doCheck = false;
  installPhase = ''cp -r . "$out" '';

  meta = with stdenv.lib; {
    description = "An open, programmable collaboration platform";
    homepage = http://foswiki.org;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

