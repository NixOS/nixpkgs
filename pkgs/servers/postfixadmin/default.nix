{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  pname = "postfixadmin";
  version = "3.3.9";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "178ibnz8cd8nalg98zifsrpvqhi1i3k9rq5fbdpwlikqvppk0h08";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
    ln -sf /etc/postfixadmin/config.local.php $out/
    ln -sf /var/cache/postfixadmin/templates_c $out/
  '';

  meta = {
    description = "Web based virtual user administration interface for Postfix mail servers";
    maintainers = with stdenv.lib.maintainers; [ globin ];
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
