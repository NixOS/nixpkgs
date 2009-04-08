{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    installer = {
      nixpkgsURL = mkOption {
        default = "";
        example = http://nixos.org/releases/nix/nixpkgs-0.11pre7577;
        description = "
          URL of the Nixpkgs distribution to use when building the
          installation CD.
        ";
      };

      repos = {
        nixos = mkOption {
          default = [ { type  = "svn"; }  ];
          example = [ { type = "svn"; url = "https://svn.nixos.org/repos/nix/nixos/branches/stdenv-updates"; target = "/etc/nixos/nixos-stdenv-updates"; }
                      { type = "git"; initialize = ''git clone git://mawercer.de/nixos $target''; update = "git pull origin"; target = "/etc/nixos/nixos-git"; }
                    ];
          description = ''
            The NixOS repository from which the system will be built.
            <command>nixos-checkout</command> will update all working
            copies of the given repositories,
            <command>nixos-rebuild</command> will use the first item
            which has the attribute <literal>default = true</literal>
            falling back to the first item. The type defines the
            repository tool added to the path. It also defines a "valid"
            repository.  If the target directory already exists and it's
            not valid it will be moved to the backup location
            <filename><replaceable>dir</replaceable>-date</filename>.
            For svn the default target and repositories are
            <filename>/etc/nixos/nixos</filename> and
            <filename>https://svn.nixos.org/repos/nix/nixos/trunk</filename>.
            For git repositories update is called after initialization
            when the repo is initialized.  The initialize code is run
            from working directory dirname
            <replaceable>target</replaceable> and should create the
            directory
            <filename><replaceable>dir</replaceable></filename>. (<command>git
            clone url nixos/nixpkgs/services</command> should do) For
            the executables used see <option>repoTypes</option>.
          '';
        };

        nixpkgs = mkOption {
          default = [ { type  = "svn"; }  ];
          description = "same as <option>repos.nixos</option>";
        };

        services = mkOption {
          default = [ { type  = "svn"; } ];
          description = "same as <option>repos.nixos</option>";
        };
      };

      repoTypes = mkOption {
        default = {
          svn = { valid = "[ -d .svn ]"; env = [ pkgs.coreutils pkgs.subversion ]; };
          git = { valid = "[ -d .git ]"; env = [ pkgs.coreutils pkgs.git pkgs.gnused /*  FIXME: use full path to sed in nix-pull */ ]; };
        };
        description = ''
          Defines, for each supported version control system
          (e.g. <literal>git</literal>), the dependencies for the
          mechanism, as well as a test used to determine whether a
          directory is a checkout created by that version control
          system.
        '';
      };

      manifests = mkOption {
        default = [http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST];
        example =
          [ http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST
            http://nixos.org/releases/nixpkgs/channels/nixpkgs-stable/MANIFEST
          ];
        description = "
          URLs of manifests to be downloaded when you run
          <command>nixos-rebuild</command> to speed up builds.
        ";
      };
    };
  };


in

###### implementation

mkIf config.services.pulseaudio.enable {
  require = [
    options
  ];

}
