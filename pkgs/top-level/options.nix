{lib, hostPlatform}:

with lib;

# Define some user flags. Each one will be passed as an argument to
# callPackage and can be used directly by packages to configure
# themselves. Note that none of these should be mutually exclusive.
# For instance enabling X11 should not imply that Wayland is disabled.

{

  lang = mkOption {
    default = "en";
    type = types.string;
    description = ''

      The target language to compile packages with support for.

    '';
  };

  withX11 = mkOption {
    default = hostPlatform.isLinux; # also BSDs?
    type = types.bool;
    description = ''

      Whether to compile packages with support for the X Window System.

    '';
  };

  withWayland = mkOption {
    default = hostPlatform.isLinux; # also BSDs?
    type = types.bool;
    description = ''

      Whether to compile packages with support for the Wayland window system.

    '';
  };

  withAlsa = mkOption {
    default = hostPlatform.isLinux;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the ALSA sound system.

    '';
  };

  withPulseAudio = mkOption {
    default = hostPlatform.isLinux;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the PulseAudio sound system.

    '';
  };

  withJack = mkOption {
    default = false;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the JACK sound system

    '';
  };

  withQt = mkOption {
    default = true;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the Qt graphical toolkit

    '';
  };

  withGtk = mkOption {
    default = false;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the GTK graphical toolkit

    '';
  };

  withApple = mkOption {
    default = hostPlatform.isDarwin;
    type = types.bool;
    description = ''

      Whether to compile packages with Apple's proprietary frameworks.

      Note that this only supports macOS currently.

    '';
  };

  withSystemd = mkOption {
    default = hostPlatform.isLinux;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the Systemd init system.

      Note that this specifically means compiling packages with the
      /Systemd/ libraries. Unit files should always be included in
      packages.

    '';
  };

  allowUnfree = mkOption {
    default = false;
    type = types.bool;
    description = ''

      Whether to support unfree software. This includes everything not
      considered free software by the Free Software Foundation.

    '';
  };

  enableDynamic = mkOption {
    default = true;
    type = types.bool;
    description = ''

      Whether to build packages with dynamic linking. This has
      historically been the default everywhere in Nixpkgs.

    '';
  };

  enableStatic = mkOption {
    default = targetPlatform.isiOS;
    type = types.bool;
    description = ''

      Whether to build packages with static linking if available. Note
      that not all packages support this.

      Packages using this option may or may not also build dynamic
      libraries. Set enableDynamic to disable those.

    '';
  };

}
