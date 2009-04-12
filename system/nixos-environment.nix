{pkgs, config, ...}:

let
  inherit (pkgs.lib) mergeOneOption mkOption;
in

{
  environment = {
    checkConfigurationOptions = mkOption {
      default = true;
      example = false;
      description = "
        If all configuration options must be checked. Non-existing options fail build.
      ";
    };

    nix = mkOption {
      default = pkgs.nixUnstable;
      example = pkgs.nixCustomFun /root/nix.tar.gz;
      merge = mergeOneOption;
      description = "
        Use non-default Nix easily. Be careful, though, not to break everything.
      ";
    };

    extraPackages = mkOption {
      default = [];
      example = [pkgs.firefox pkgs.thunderbird];
      description = "
        This option allows you to add additional packages to the system
        path.  These packages are automatically available to all users,
        and they are automatically updated every time you rebuild the
        system configuration.  (The latter is the main difference with
        installing them in the default profile,
        <filename>/nix/var/nix/profiles/default</filename>.  The value
        of this option must be a function that returns a list of
        packages.  The function will be called with the Nix Packages
        collection as its argument for convenience.
      ";
    };


    pathsToLink = mkOption {
      default = ["/bin" "/sbin" "/lib" "/share/man" "/share/info" "/man" "/info"];
      example = ["/"];
      description = "
        Lists directories to be symlinked in `/var/run/current-system/sw'.
      ";
    };

    cleanStart = mkOption {
      default = false;
      example = true;
      description = "
        There are some times when you want really small system for specific 
        purpose and do not want default package list. Setting 
        <varname>cleanStart</varname> to <literal>true</literal> allows you 
        to create a system with empty path - only extraPackages will be 
        included.
      ";
    };
  };
}
