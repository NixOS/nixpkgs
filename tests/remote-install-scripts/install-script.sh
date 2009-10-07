dd if=/dev/zero of=/dev/sda bs=1048576 count=1

sfdisk /dev/sda -uM << EOF
,512,L
,1024,S
,,L
EOF

mkfs.ext3 /dev/sda1 ; mkswap /dev/sda2 ; mkfs.ext3 /dev/sda3

mount /dev/sda3 /mnt ; mkdir /mnt/boot ; mount /dev/sda1 /mnt/boot

mkdir -p /mnt/etc/nixos

cat > /mnt/etc/nixos/configuration.nix <<EOF

{pkgs, config, ...}: {
  boot = {
    grubDevice = "/dev/sda";
    copyKernels = true;
    bootMount = "(hd0,0)";
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/sda3";
    }
    { mountPoint = "/boot";
      device = "/dev/sda1";
      neededForBoot = true;
    }
  ];

  swapDevices = [
    { device = "/dev/sda2"; }
  ];
  
  services = {
    sshd = {
      enable = true;
    };

    extraJobs = [
      {
        name = "Host-call-back";
        job = ''
          start on network-interfaces/started
          script
            while ! /var/run/current-system/sw/sbin/ifconfig eth0 | 
                /var/run/current-system/sw/bin/grep "inet addr:" &>/dev/null; do
                    sleep 1;
            done
            echo -e "Installation finished\nOK" | /var/run/current-system/sw/bin/socat stdio tcp:10.0.2.2:4424 | {
                read;
                if [ "\\\$REPLY" = "reboot" ] ; then 
                        /var/run/current-system/sw/sbin/start ctrl-alt-delete;
                fi;
            }
          end script
        '';
      }
    ];
  };

  fonts = { 
    enableFontConfig = false; 
  };

  environment = {
    systemPackages = [
      pkgs.socat (pkgs.lowPrio pkgs.nixUnstable)
    ];
    nix = pkgs.nixCustomFun (pkgs.nixUnstable.src)
      ""
      ["nix-reduce-build" "nix-http-export.cgi"]
      ["--with-docbook-xsl=\\\${pkgs.docbook5_xsl}/xml/xsl/docbook/"];
  };
}

EOF

nixos-install

echo Installation finished

start ctrl-alt-delete

