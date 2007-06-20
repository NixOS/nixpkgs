{stdenv, fetchurl, coreutils}:
stdenv.mkDerivation {
  name = "sudo";

  src = fetchurl {
    url = ftp://sunsite.ualberta.ca/pub/Mirror/sudo/sudo-1.6.8p12.tar.gz;
    md5 = "b29893c06192df6230dd5f340f3badf5";
  };

  postConfigure = "sed -e '/_PATH_MV/d; /_PATH_VI/d' -i config.h ; echo '#define _PATH_MV \"/var/run/current-system/sw/bin/mv\"' >> config.h; echo '#define _PATH_VI \"/var/run/current-system/sw/bin/vi\"' >> config.h; echo '#define EDITOR _PATH_VI' >>config.h ";

  makeFlags = " install_gid=nixbld install_uid=nixbld1 ";

  installFlags = " sudoers_uid=nixbld1 sudoers_gid=nixbld sysconfdir=$(prefix)/etc ";

  buildInputs = [coreutils];
}
