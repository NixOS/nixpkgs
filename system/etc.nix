{config, pkgs, upstartJobs, systemPath, wrapperDir}:

let 

  optional = option: file:
    if config.get option then [file] else [];

in
    
import ../helpers/make-etc.nix {
  inherit (pkgs) stdenv;

  configFiles = [

    { # TCP/UDP port assignments.
      source = pkgs.iana_etc + "/etc/services";
      target = "services";
    }

    { # IP protocol numbers.
      source = pkgs.iana_etc + "/etc/protocols";
      target = "protocols";
    }

    { # Hostname-to-IP mappings.
      source = ./etc/hosts;
      target = "hosts";
    }

    { # Name Service Switch configuration file.  Required by the C library.
      source = ./etc/nsswitch.conf;
      target = "nsswitch.conf";
    }

    { # Configuration file for the system logging daemon.
      source = ./etc/syslog.conf;
      target = "syslog.conf";
    }

    { # Friendly greeting on the virtual consoles.
      source = ./etc/issue;
      target = "issue";
    }

    { # Configuration for pwdutils (login, passwd, useradd, etc.).
      # You cannot login without it!
      source = ./etc/login.defs;
      target = "login.defs";
    }

    { # The Upstart events defined above.
      source = upstartJobs + "/etc/event.d";
      target = "event.d";
    }

    { # Configuration for passwd and friends (e.g., hash algorithm
      # for /etc/passwd).
      source = ./etc/default/passwd;
      target = "default/passwd";
    }

    { # Dhclient hooks for emitting ip-up/ip-down events.
      source = pkgs.substituteAll {
        src = ./etc/dhclient-exit-hooks;
        inherit (pkgs) upstart;
      };
      target = "dhclient-exit-hooks";
    }

    { # Script executed when the shell starts.
      source = pkgs.substituteAll {
        src = ./etc/profile.sh;
        inherit systemPath wrapperDir;
        inherit (pkgs) kernel;
        timeZone = config.get ["time" "timeZone"];
      };
      target = "profile";
    }

  ]

  # Configuration file for fontconfig used to locate
  # (X11) client-rendered fonts.
  ++ (optional ["fonts" "enableFontConfig"] { 
    source = pkgs.runCommand "fonts.conf"
      { 
        fontDirectories = [
          # - the user's .fonts directory
          "~/.fonts"
          # - the user's current profile
          "~/.nix-profile/lib/X11/fonts"
          # - the default profile
          "/nix/var/nix/profiles/default/lib/X11/fonts"
          # - a few statically built locations
          pkgs.xorg.fontbhttf
          pkgs.xorg.fontbh100dpi
          pkgs.xorg.fontbhlucidatypewriter100dpi
          pkgs.freefont_ttf
        ];
        buildInputs = [pkgs.libxslt];
        inherit (pkgs) fontconfig;
      }
      "xsltproc --stringparam fontDirectories \"$fontDirectories\" \\
          ${./etc/fonts/make-fonts-conf.xsl} $fontconfig/etc/fonts/fonts.conf \\
          > $out
      ";
    target = "fonts/fonts.conf";
  })

  # LDAP configuration.
  ++ (optional ["users" "ldap" "enable"] {
    source = import etc/ldap.conf.nix {
      inherit (pkgs) writeText;
      inherit config;
    };
    target = "ldap.conf";
  })
    
  # A bunch of PAM configuration files for various programs.
  ++ (map
    (program:
      { source = pkgs.substituteAll {
          src = ./etc/pam.d + ("/" + program);
          inherit (pkgs) pam_unix2;
          pam_ldap =
            if config.get ["users" "ldap" "enable"]
            then pkgs.pam_ldap
            else "/no-such-path";
          inherit (pkgs.xorg) xauth;
        };
        target = "pam.d/" + program;
      }
    )
    [
      "login"
      "su"
      "other"
      "passwd"
      "shadow"
      "sshd"
      "useradd"
      "common-auth"
      "common-account"
      "common-password"
      "common-session"
    ]
  );
}