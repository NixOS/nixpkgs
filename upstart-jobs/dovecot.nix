{config, pkgs}:
let 
  startingDependency = if config.services.gw6c.enable then "gw6c" else "network-interfaces";

  cfg = config.services.dovecot;
  idList = import ../system/ids.nix;

  dovecotConf = 
  ''
    base_dir = /var/run/dovecot/ 

    protocols = imap imaps pop3 pop3s
  ''
  + (if cfg.sslServerCert!="" then
  ''
    ssl_cert_file = ${cfg.sslServerCert}
    ssl_key_file = ${cfg.sslServerKey}
    ssl_ca_file = ${cfg.sslCACert}
  '' else ''
    ssl_disable = yes
    disable_plaintext_auth = no
  '')


  + ''
    login_user = ${cfg.user}
    login_chroot = no

    mail_location = maildir:/var/spool/mail/%u

    maildir_copy_with_hardlinks = yes

    auth default {
      mechanisms = plain login 
      userdb passwd {
      }
      passdb pam {
      }
      user = root 
    }
    auth_debug = yes
    auth_verbose = yes

    pop3_uidl_format = %08Xv%08Xu
  ''
  ;
  confFile = pkgs.writeText "dovecot.conf" dovecotConf;

  pamdFile = pkgs.writeText "dovecot.pam" ''
    auth	include	common
    account	include common
  '';

in
{
  name = "dovecot";
  users = [{
    name = cfg.user;
    uid = idList.uids.dovecot;
    description = "Dovecot user";
    group = cfg.group;
  }];
  groups = [{
    name = cfg.group;
    gid = idList.gids.dovecot;
  }];

  job = ''
    description "Dovecot IMAP/POP3 server"

    start on ${startingDependency}/started
    stop on never

    start script
      ${pkgs.coreutils}/bin/mkdir -p /var/run/dovecot /var/run/dovecot/login 
      ${pkgs.coreutils}/bin/chown -R ${cfg.user}.${cfg.group} /var/run/dovecot
    end script 

    respawn ${pkgs.dovecot}/sbin/dovecot -F -c ${confFile}
  '';

  extraEtc = [{ 
    source = pamdFile;
    target = "pam.d/dovecot";
  }];
}

