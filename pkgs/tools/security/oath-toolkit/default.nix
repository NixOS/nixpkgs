{ stdenv, fetchFromGitLab, pam, xmlsec, autoreconfHook, pkgconfig, libxml2, gtkdoc, perl, gengetopt, bison, help2man }:

let
  securityDependency =
    if stdenv.isDarwin then xmlsec
    else pam;

in stdenv.mkDerivation rec {
  name = "oath-toolkit-2.6.2";

  src = fetchFromGitLab {
    owner = "oath-toolkit";
    repo = "oath-toolkit";
    rev = "0dffdec9c5af5c89a5af43add29d8275eefe7414";
    sha256 = "0n2sl444723f1k0sjmc0mzdwslx51yxac39c2cx2bl3ykacgfv74";
  };

  buildInputs = [ securityDependency libxml2 perl gengetopt bison ];

  nativeBuildInputs = [ autoreconfHook gtkdoc help2man pkgconfig ];

  # man file generation fails when true
  enableParallelBuilding = false;

  configureFlags = [ "--disable-pskc" ];

  # Replicate the steps from cfg.mk
  preAutoreconf = ''
    printf "gdoc_MANS =\ngdoc_TEXINFOS =\n" > liboath/man/Makefile.gdoc
    printf "gdoc_MANS =\ngdoc_TEXINFOS =\n" > libpskc/man/Makefile.gdoc
    touch ChangeLog
  '';

  meta = with stdenv.lib; {
    description = "Components for building one-time password authentication systems";
    homepage = http://www.nongnu.org/oath-toolkit/;
    platforms = with platforms; linux ++ darwin;
  };
}
