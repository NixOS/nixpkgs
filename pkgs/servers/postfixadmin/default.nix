{ fetchFromGitHub, stdenv, lib }:

stdenv.mkDerivation rec {
  pname = "postfixadmin";
  version = "3.3.13";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-46bc34goAcRvaiyW7z0AvIcd8n61TL6vgLQ+y7nNKBQ=";
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
