{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {

    nix = {

      maxJobs = mkOption {
        default = 1;
        example = 2;
        description = "
          This option defines the maximum number of jobs that Nix will try
          to build in parallel.  The default is 1.  You should generally
          set it to the number of CPUs in your system (e.g., 2 on a Athlon
          64 X2).
        ";
      };

      useChroot = mkOption {
        default = false;
        example = true;
        description = "
          If set, Nix will perform builds in a chroot-environment that it
          will set up automatically for each build.  This prevents
          impurities in builds by disallowing access to dependencies
          outside of the Nix store.
        ";
      };

      extraOptions = mkOption {
        default = "";
        example = "
          gc-keep-outputs = true
          gc-keep-derivations = true
        ";
        description = "
          This option allows to append lines to nix.conf. 
        ";
      };

      distributedBuilds = mkOption {
        default = false;
        description = "
          Whether to distribute builds to the machines listed in
          <option>nix.buildMachines</option>.
        ";
      };

      buildMachines = mkOption {
        example = [
          { hostName = "voila.labs.cs.uu.nl";
            sshUser = "nix";
            sshKey = "/root/.ssh/id_buildfarm";
            system = "powerpc-darwin";
            maxJobs = 1;
          }
          { hostName = "linux64.example.org";
            sshUser = "buildfarm";
            sshKey = "/root/.ssh/id_buildfarm";
            system = "x86_64-linux";
            maxJobs = 2;
          }
        ];
        description = "
          This option lists the machines to be used if distributed
          builds are enabled (see
          <option>nix.distributedBuilds</option>).  Nix will perform
          derivations on those machines via SSh by copying the inputs to
          the Nix store on the remote machine, starting the build, then
          copying the output back to the local Nix store.  Each element
          of the list should be an attribute set containing the
          machine's host name (<varname>hostname</varname>), the user
          name to be used for the SSH connection
          (<varname>sshUser</varname>), the Nix system type
          (<varname>system</varname>, e.g.,
          <literal>\"i686-linux\"</literal>), the maximum number of jobs
          to be run in parallel on that machine
          (<varname>maxJobs</varname>), and the path to the SSH private
          key to be used to connect (<varname>sshKey</varname>).  The
          SSH private key should not have a passphrase, and the
          corresponding public key should be added to
          <filename>~<replaceable>sshUser</replaceable>/authorized_keys</filename>
          on the remote machine.
        ";
      };
   
      proxy = mkOption {
        default = "";
        description = "
          This option specifies the proxy to use for fetchurl. The real effect 
          is just exporting http_proxy, https_proxy and ftp_proxy with that
          value.
        ";
        example = "http://127.0.0.1:3128";
      };

      # Environment variables for running Nix.
      envVars = mkOption {
        internal = true;
        default = "";
        description = "
          Define the environment variables used by nix to 
        ";

        merge = pkgs.lib.mergeStringOption;

        # other option should be used to define the content instead of using
        # the apply function.
        apply = conf: ''
          export NIX_CONF_DIR=/nix/etc/nix

          # Enable the copy-from-other-stores substituter, which allows builds
          # to be sped up by copying build results from remote Nix stores.  To
          # do this, mount the remote file system on a subdirectory of
          # /var/run/nix/remote-stores.
          export NIX_OTHER_STORES=/var/run/nix/remote-stores/*/nix
          
        '' + # */
        (if config.nix.distributedBuilds then
          ''
            export NIX_BUILD_HOOK=${config.environment.nix}/libexec/nix/build-remote.pl
            export NIX_REMOTE_SYSTEMS=/etc/nix.machines
            export NIX_CURRENT_LOAD=/var/run/nix/current-load
          ''
        else "")
        +
        (if config.nix.proxy != "" then
          ''
            export http_proxy=${config.nix.proxy}
            export https_proxy=${config.nix.proxy}
            export ftp_proxy=${config.nix.proxy}
          ''
        else "")
        + conf;
      };


      services = {
        pulseaudio = {
          enable = mkOption {
            default = false;
            description = ''
              Whether to enable the PulseAudio system-wide audio server.
              Note that the documentation recommends running PulseAudio
              daemons per-user rather than system-wide on desktop machines.
            '';
          };

          logLevel = mkOption {
            default = "notice";
            example = "debug";
            description = ''
              A string denoting the log level: one of
              <literal>error</literal>, <literal>warn</literal>,
              <literal>notice</literal>, <literal>info</literal>,
              or <literal>debug</literal>.
            '';
          };
        };
      };
    };
  };
in

###### implementation

let 
  binsh = config.system.build.binsh;
  nixEnvVars = config.nix.envVars;
  inherit (config.environment) nix;
in

{
  require = [
    options
  ];

  environment = {
    etc = [
      { # Nix configuration.
        source =
          let
            # Tricky: if we're using a chroot for builds, then we need
            # /bin/sh in the chroot (our own compromise to purity).
            # However, since /bin/sh is a symlink to some path in the
            # Nix store, which furthermore has runtime dependencies on
            # other paths in the store, we need the closure of /bin/sh
            # in `build-chroot-dirs' - otherwise any builder that uses
            # /bin/sh won't work.
            binshDeps = pkgs.writeReferencesToFile binsh;
  
            # Likewise, if chroots are turned on, we need Nix's own
            # closure in the chroot.  Otherwise nix-channel and nix-env
            # won't work because the dependencies of its builders (like
            # coreutils and Perl) aren't visible.  Sigh.
            nixDeps = pkgs.writeReferencesToFile config.environment.nix;
          in 
            pkgs.runCommand "nix.conf" {extraOptions = config.nix.extraOptions; } ''
              extraPaths=$(for i in $(cat ${binshDeps} ${nixDeps}); do if test -d $i; then echo $i; fi; done)
              cat > $out <<END
              # WARNING: this file is generated.
              build-users-group = nixbld
              build-max-jobs = ${toString (config.nix.maxJobs)}
              build-use-chroot = ${if config.nix.useChroot then "true" else "false"}
              build-chroot-dirs = /dev /dev/pts /proc /bin $(echo $extraPaths)
              $extraOptions
              END
            '';
        target = "nix.conf"; # will be symlinked from /nix/etc/nix/nix.conf in activate-configuration.sh.
      }
    ];
  };

  services = {
    extraJobs = [{
      name = "nix-daemon";
      
      job = ''
        start on startup
        stop on shutdown
        respawn
        script
          export PATH=${if config.nix.distributedBuilds then "${pkgs.openssh}/bin:" else ""}${pkgs.openssl}/bin:${nix}/bin:$PATH
          ${nixEnvVars}
          exec ${pkgs.nix}/bin/nix-worker --daemon > /dev/null 2>&1
        end script
      '';
    }];
  };
}
