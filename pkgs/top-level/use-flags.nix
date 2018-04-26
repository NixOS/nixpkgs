{lib, stdenv}:

with lib;

# Define some user flags. Note that none of these should be mutually
# exclusive. For instance enabling X11 should not imply that Wayland
# is disabled.

{

  lang = mkOption {
    default = "en";
    type = types.string;
    description = ''

      The target language to compile packages with support for.

    '';
  };

  withX11 = mkOption {
    default = stdenv.isLinux || stdenv.isBSD;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the X Window System.

    '';
  };

  withWayland = mkOption {
    default = stdenv.isLinux || stdenv.isBSD;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the Wayland window system.

    '';
  };

  withAlsa = mkOption {
    default = stdenv.isLinux;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the ALSA sound system.

    '';
  };

  withPulseAudio = mkOption {
    default = stdenv.isLinux;
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

  withGTK = mkOption {
    default = false;
    type = types.bool;
    description = ''

      Whether to compile packages with support for the GTK graphical toolkit

    '';
  };

  withApple = mkOption {
    default = stdenv.isDarwin;
    type = types.bool;
    description = ''

      Whether to compile packages with Apple's proprietary frameworks.

      Note that this only supports macOS currently.

    '';
  };

  withSystemd = mkOption {
    default = stdenv.isLinux;
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

}
