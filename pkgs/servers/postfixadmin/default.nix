{ fetchFromGitHub, stdenv, lib }:

stdenv.mkDerivation rec {
  pname = "postfixadmin";
  version = "3.3.11";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-jOO0AVcCmBxHLaWQOwvt7OFKAcAYPTVHTdQz1ZaYIqE=";
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
    ln -sf /etc/postfixadmin/config.local.php $out/
    ln -sf /var/cache/postfixadmin/templates_c $out/
  '';

  meta = {
    description = "Web based virtual user administration interface for Postfix mail servers";
    homepage = "https://postfixadmin.sourceforge.io/";
    maintainers = with lib.maintainers; [ globin ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
