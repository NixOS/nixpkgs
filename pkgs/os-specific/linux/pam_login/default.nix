{stdenv, fetchurl, pam}:
   
stdenv.mkDerivation {
  name = "pam_login-3.35";
   
  src = fetchurl {
    url = ftp://ftp.suse.com/pub/people/kukuk/pam/pam_login/pam_login-3.35.tar.bz2;
    sha256 = "1w2hpwjhmwjhf8rg789xpl0hibahqlr3ccivfy3m4kgrm5gf04kv";
  };

  patches = [ ./sys-stat-h.patch ];

  # To overcome a gcc 4.4 warning:
  # "#ident is a deprecated GCC extension"
  postPatch = ''
    sed -i s/-Werror// configure
  '';

  buildInputs = [pam];
}
