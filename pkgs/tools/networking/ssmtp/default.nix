{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "ssmtp-2.61-12";
  src = fetchurl {
    url = http://ftp.debian.org/debian/pool/main/s/ssmtp/ssmtp_2.61.orig.tar.gz;
    sha256 = "2151ad18cb73f9a254f796dde2b48be7318b45410b59fedbb258db5a41044fb5";
  };
  patches = [
    (fetchurl {
      url = http://ftp.debian.org/debian/pool/main/s/ssmtp/ssmtp_2.61-12.diff.gz;
      sha256 = "2eb5b2af76d220f14e5133ec4078bab531209fb2f9f8f4e780a0ab8de4818d39";
     })
  ];
  postConfigure = [
    "sed -e '/INSTALLED_CONFIGURATION_FILE/d' "
    "    -e 's|\\(DSSMTPCONFDIR.*\\).(.*)\\(.*$\\)|\\1/etc/ssmtp\\2|'"
    "    -e 's|\\(DCONFIGURATION_FILE.*\\).(.*)\\(.*$\\)|\\1/etc/ssmtp/ssmtp.conf\\2|'"
    "    -e 's|\\(DREVALIASES_FILE.*\\).(.*)\\(.*$\\)|\\1/etc/ssmtp/revaliases\\2|'"
    "    -e \"s| /lib| $out/lib|\" -i Makefile"
  ];
  preInstall = "ensureDir $out/lib";
  installTargets = [ "install" "install-sendmail" ];
  postInstall = "install ssmtp.conf $out/etc/ssmtp ";
}
