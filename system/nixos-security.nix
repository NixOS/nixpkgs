{pkgs, config, ...}:
let
  inherit (pkgs.lib) mergeOneOption mkOption mkIf;
in
{
  require = [
    {
      security = {
        setuidPrograms = mkOption {
          default = [
            "passwd" "su" "crontab" "ping" "ping6"
            "fusermount" "wodim" "cdrdao" "growisofs"
          ];
          description = "
            Only the programs from system path listed her will be made setuid root
            (through a wrapper program).  It's better to set
            <option>security.extraSetuidPrograms</option>.
          ";
        };

        extraSetuidPrograms = mkOption {
          default = [];
          example = ["fusermount"];
          description = "
            This option lists additional programs that must be made setuid
            root.
          ";
        };

        setuidOwners = mkOption {
          default = [];
          example = [{
            program = "sendmail";
            owner = "nodody";
            group = "postdrop";
            setuid = false;
            setgid = true;
          }];
          description = ''
            List of non-trivial setuid programs from system path, like Postfix sendmail. Default 
            should probably be nobody:nogroup:false:false - if you are bothering
            doing anything with a setuid program, "root.root u+s g-s" is not what
            you are aiming at..
          '';
        };
      };
    }
  ];
}
