{pkgs, config, ...}:

with pkgs.lib;

{
  environment = {
    checkConfigurationOptions = mkOption {
      default = true;
      example = false;
      description = "
        If all configuration options must be checked. Non-existing options fail build.
      ";
    };
  };
}
