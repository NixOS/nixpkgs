{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2016-08-25";
  name = "phabricator-${version}";

  src = fetchFromGitHub {
    owner = "phacility";
    repo = "phabricator";
    rev = "d135b3f2d56f0ecc4c3c184ed18fdb13cc063e13";
    sha256 = "1m4kr63i4ym2yz1sfckik97zqyd61lw1p7djagyk3jqiz1j09233";
  };

  srcLibphutil = fetchFromGitHub {
    owner = "phacility";
    repo = "libphutil";
    rev = "5fd1af8b4f2b9631e2ceb06bd88d21f2416123c2";
    sha256 = "06zkfkgwni8prr3cnsbf1h4s30k4v00y8ll1bcl6282xynnh3gf6";
  };

  srcArcanist = fetchFromGitHub {
    owner = "phacility";
    repo = "arcanist";
    rev = "89e8b48523844cc3eff8b775f8fae49e85f8fc22";
    sha256 = "00h7rs6iwi72jhcs553yp8xv9yl3isjdzdsbkdnz55nhv4nzhbi1";
  };

  buildPhase = ''
    substituteInPlace externals/phpmailer/class.phpmailer.php \
      --replace /usr/sbin/sendmail /var/setuid-wrappers/sendmail
    substituteInPlace externals/phpmailer/class.phpmailer-lite.php \
      --replace /usr/sbin/sendmail /var/setuid-wrappers/sendmail
  '';

  installPhase = ''
    mkdir -p $out
    cp -R ${srcLibphutil} $out/libphutil
    cp -R ${srcArcanist} $out/arcanist
    cp -R . $out/phabricator
    mv $out/phabricator/conf $out/phabricator/conf.dist
    ln -sf /run/phabricator/conf $out/phabricator/conf
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
