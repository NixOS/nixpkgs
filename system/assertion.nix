{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption filter concatMap concatStringsSep;
  failed = map (x : x.message) (filter (x: ! x.assertion) config.assertions);
in

{

  assertions = mkOption {
    default = [];
    example = [{ assertion = false; msg = "you can't enable this for that reason"; }];
    merge = pkgs.lib.mergeListOption;
    description = ''
      Add something like this
      assertions = mkAlways [ { assertion = false; message = "false should have been true"; } ];
      to your upstart-job.
    '';
  };

  environment = {
    # extraPackages are evaluated always. Thus the assertions are checked as well. hacky!
    extraPackages = if [] == failed then [] else throw "\n!! failed assertions: !!\n${concatStringsSep "\n" (map (x: "- ${x}") failed)}";
  };
}
