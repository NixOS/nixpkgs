{ stdenv, fetchgit, pam, xmlsec, autoconf, automake, libtool, pkgconfig, libxml2, gtkdoc, perl, gengetopt, bison, help2man }:

let
  securityDependency =
    if stdenv.isDarwin then xmlsec
    else pam;
in
stdenv.mkDerivation rec {
  name = "oath-toolkit-2.6.2";

  src = fetchgit {
    url = "https://gitlab.com/oath-toolkit/oath-toolkit.git";
    sha256 = "0n2sl444723f1k0sjmc0mzdwslx51yxac39c2cx2bl3ykacgfv74";
    rev = "0dffdec9c5af5c89a5af43add29d8275eefe7414";
  };

  buildInputs = [ securityDependency automake autoconf libtool pkgconfig libxml2 gtkdoc perl gengetopt bison help2man ];

  configureFlags = [ "--disable-pskc" ];

  preConfigure = ''
     # Replicate the steps from cfg.mk
     printf "gdoc_MANS =\ngdoc_TEXINFOS =\n" > liboath/man/Makefile.gdoc
     printf "gdoc_MANS =\ngdoc_TEXINFOS =\n" > libpskc/man/Makefile.gdoc
     touch ChangeLog
     autoreconf --force --install
  '';

  meta = {
    homepage = http://www.nongnu.org/oath-toolkit/;
    description = "Components for building one-time password authentication systems";
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
