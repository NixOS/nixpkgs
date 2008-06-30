{config, pkgs} : 
let
  startingDependency = if config.services.gw6c.enable then "gw6c" else "network-interfaces";

  cfg = config.services.postfix;
  user = cfg.user;
  group = cfg.group;
  setgidGroup = cfg.setgidGroup;
  idList = import ../system/ids.nix;

  optionalString = pkgs.lib.optionalString;
  mainCf = 
  ''
    queue_directory = /var/postfix/queue
    command_directory = ${pkgs.postfix}/sbin
    daemon_directory = ${pkgs.postfix}/libexec/postfix

    mail_owner = ${user}
    default_privs = nobody

  ''
  + optionalString (config.services.gw6c.enable || config.networking.nativeIPv6) (''
    inet_protocols = all
  '')
  +
  (if cfg.networks!=null then
    (''
      mynetworks = ${toString cfg.networks}
    '') 
  else if (cfg.networksStyle != "") then
    (''
      mynetworks_style = ${cfg.networksStyle} 
    '')
  else
    # Postfix default is subnet, but let's play safe
    (''
      mynetworks_style = host
    '')
  )
  + optionalString (cfg.hostname != "") (''
    myhostname = ${cfg.hostname}
  '')
  + optionalString (cfg.domain != "") (''
    mydomain = ${cfg.domain}
  '')
  + optionalString (cfg.origin != "") (''
    myorigin = ${cfg.origin}
  '')
  + optionalString (cfg.destination != null) (''
    mydestination = ${toString cfg.destination}
  '')
  + optionalString (cfg.relayDomains != null) (''
    relay_domains = ${toString cfg.relayDomains}
  '')
  + ''
    local_recipient_maps = 
  ''
  + (''
    relayhost = ${if cfg.lookupMX || cfg.relayHost == "" then 
        cfg.relayHost 
      else 
        "[" + cfg.relayHost + "]"}
  '')
  + (''
    alias_maps = hash:/var/postfix/conf/aliases

    mail_spool_directory = /var/spool/mail/

    setgid_group = ${setgidGroup}
  '')
  + optionalString (cfg.sslCert != "") (''

    smtp_tls_CAfile = ${cfg.sslCACert}
    smtp_tls_cert_file = ${cfg.sslCert}
    smtp_tls_key_file = ${cfg.sslKey}

    smtp_use_tls = yes

    smtpd_tls_CAfile = ${cfg.sslCACert}
    smtpd_tls_cert_file = ${cfg.sslCert}
    smtpd_tls_key_file = ${cfg.sslKey}

    smtpd_use_tls = yes 

    recipientDelimiter = ${cfg.recipientDelimiter}

  '')
  ;

  aliases = 
    (optionalString (cfg.postmasterAlias != "") (''
      postmaster: ${cfg.postmasterAlias}
    ''))
    +
    (optionalString (cfg.rootAlias != "") (''
      root: ${cfg.rootAlias}
    ''))
    + cfg.extraAliases
  ;

  aliasesFile = pkgs.writeText "postfix-aliases" aliases;
  mainCfFile = pkgs.writeText "postfix-main.cf" mainCf;
 
in
{
  name = "postfix";
  users = [
    { name = user;
      description = "Postfix mail server user";
      uid = idList.uids.postfix;
      group = group;
    }
  ];

  groups = [
    { name = group; 
      gid = idList.gids.postfix;
    }
    { name = setgidGroup; 
      gid = idList.gids.postdrop;
    }
  ];


  # I copy _lots_ of shipped configuration filed 
  # that can be left as is. I am afraid the exact
  # will list slightly change in next Postfix 
  # release, so listing them all one-by-one in an 
  # accurate way is unlikely to be better.
  job = ''
    description "Postfix mail server job"

    start on ${startingDependency}/started
    stop on never

    script 
        if ! [ -d /var/spool/postfix ]; then
          ${pkgs.coreutils}/bin/mkdir -p /var/spool/mail /var/postfix/conf /var/postfix/queue
        fi
          
	${pkgs.coreutils}/bin/chown -R ${user}.${group} /var/postfix 
	${pkgs.coreutils}/bin/chown -R ${user}.${setgidGroup} /var/postfix/queue 
	${pkgs.coreutils}/bin/chmod -R ug+rwX /var/postfix/queue 
	${pkgs.coreutils}/bin/chown root.root /var/spool/mail
	${pkgs.coreutils}/bin/chmod a+rwxt /var/spool/mail
        
	ln -sf ${pkgs.postfix}/share/postfix/conf/* /var/postfix/conf

        ln -sf ${aliasesFile} /var/postfix/conf/aliases
        ln -sf ${mainCfFile} /var/postfix/conf/main.cf

        ${pkgs.postfix}/sbin/postalias -c /var/postfix/conf /var/postfix/conf/aliases
        
        ${pkgs.postfix}/sbin/postfix -c /var/postfix/conf start 
    end script
  '';

  extraEtc = [
    { source = "/var/postfix/conf";
      target = "postfix";
    }
  ];
}
