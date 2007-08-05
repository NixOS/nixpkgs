{stdenv, fetchurl, coreutils, pam}:
stdenv.mkDerivation {
  name = "sudo-1.6.9";

  src = fetchurl {
    url = ftp://sunsite.ualberta.ca/pub/Mirror/sudo/sudo-1.6.9p3.tar.gz;
    md5 = "21791b0bfb14fe1dc508fdcfaae9bacc";
  };

  postConfigure = "sed -e '/_PATH_MV/d; /_PATH_VI/d' -i config.h ; echo '#define _PATH_MV \"/var/run/current-system/sw/bin/mv\"' >> config.h; echo '#define _PATH_VI \"/var/run/current-system/sw/bin/vi\"' >> config.h; echo '#define EDITOR _PATH_VI' >>config.h ";

  makeFlags = " install_gid=nixbld install_uid=nixbld1 ";

  installFlags = " sudoers_uid=nixbld1 sudoers_gid=nixbld sysconfdir=$(prefix)/etc ";

  buildInputs = [coreutils pam];
}
