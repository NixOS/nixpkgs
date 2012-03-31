{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, src
, preConfigure ? ""
, autoconf ? null, automake ? null, libtool ? null
, bison ? null
, flex ? null
, w3m ? null
, libxml2 ? null
, docbook5_xsl ? null, libxslt ? null
, docbook5 ? null, docbook_xml_dtd_43 ? null 
, perlPackages
, boehmgc ? null
, pkgconfig ? null
, sqlite ? null
, configureFlags ? []
, lib
, enableScripts ? []
}:

stdenv.mkDerivation {
  name = "nix-custom";
  
  inherit src;

  buildInputs = [perl curl openssl bzip2 ] 
  	++ (if automake != null then [automake] else [])
  	++ (if autoconf != null then [autoconf] else [])
  	++ (if libtool != null then [libtool] else [])
  	++ (if bison != null then [bison] else [])
  	++ (if flex != null then [flex] else [])
  	++ (if docbook5_xsl != null then [docbook5_xsl] else [])
  	++ (if libxslt != null then [libxslt] else [])
  	++ (if docbook5 != null then [docbook5] else [])
  	++ (if docbook_xml_dtd_43 != null then [docbook_xml_dtd_43] else [])
  	++ (if w3m != null then [w3m] else [])
  	++ (if libxml2 != null then [libxml2] else [])
  	++ (if boehmgc != null then [boehmgc] else [])
  	++ (if sqlite != null then [sqlite] else [])
  	++ (if pkgconfig != null then [pkgconfig] else [])
  ;

  preConfigure = 
    (lib.concatMapStrings (script:
      ''
        sed -e '/bin_SCRIPTS = /a${script} \\' -i scripts/Makefile.am
      ''
    ) enableScripts)
    + preConfigure
    + "\n./bootstrap.sh";

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bdb=${db4} --with-bzip2=${bzip2}
    --with-sqlite=${sqlite}
    --disable-init-state
    --with-dbi=${perlPackages.DBI}/lib/perl5/site_perl
    --with-dbd-sqlite=${perlPackages.DBDSQLite}/lib/perl5/site_perl
    ${toString configureFlags}
  '';

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPL";
  };
}
