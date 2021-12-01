# sets of small configurations:
# Each configuration
rec {
  # has 2 arguments pkgs and this.
  configA = pkgs: this: {
    # Can depends on other configuration
    require = configB;

    # Defines new options
    optionA = pkgs.lib.mkOption {
      # With default values
      default = false;
      # And merging functions.
      merge = pkgs.lib.mergeEnableOption;
    };

    # Add a new definition to other options.
    optionB = this.optionA;
  };

  # Can be used for option header.
  configB = pkgs: this: {
    # Can depends on more than one configuration.
    require = [ configC configD ];

    optionB = pkgs.lib.mkOption {
      default = false;
    };

    # Is not obliged to define other options.
  };

  configC = pkgs: this: {
    require = [ configA ];

    optionC = pkgs.lib.mkOption {
      default = false;
    };

    # Use the default value if it is not overwritten.
    optionA = this.optionC;
  };

  # Can also be used as option configuration only.
  # without any arguments (backward compatibility)
  configD = {
    # Is not forced to specify the require attribute.

    # Is not force to make new options.
    optionA = true;
    optionD = false;
  };
}
