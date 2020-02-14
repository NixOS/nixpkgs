{ stdenv, fetchFromGitLab, fetchpatch, pam, xmlsec, autoreconfHook, pkgconfig, libxml2, gtk-doc, perl, gengetopt, bison, help2man }:

let
  securityDependency =
    if stdenv.isDarwin then xmlsec
    else pam;

in stdenv.mkDerivation {
  name = "oath-toolkit-2.6.2";

  src = fetchFromGitLab {
    owner = "oath-toolkit";
    repo = "oath-toolkit";
    rev = "0dffdec9c5af5c89a5af43add29d8275eefe7414";
    sha256 = "0n2sl444723f1k0sjmc0mzdwslx51yxac39c2cx2bl3ykacgfv74";
  };

  patches = [
    # fix for glibc>=2.28
    (fetchpatch {
      name   = "new_glibc_check.patch";
      url    = "https://sources.debian.org/data/main/o/oath-toolkit/2.6.1-1.3/debian/patches/new-glibc-check.patch";
      sha256 = "0h75xyy3xsl485v7w27yqkks6z9sgsjmrv6wiswy15fdj5wyciv3";
    })
  ];

  buildInputs = [ securityDependency libxml2 perl gengetopt bison ];

  nativeBuildInputs = [ autoreconfHook gtk-doc help2man pkgconfig ];

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
    homepage = https://www.nongnu.org/oath-toolkit/;
    platforms = with platforms; linux ++ darwin;
  };
}
