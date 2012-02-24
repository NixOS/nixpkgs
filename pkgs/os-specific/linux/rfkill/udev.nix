{ stdenv }:

# Provides a facility to hook into rfkill changes.
#
# Exemplary usage:
#
# Add this package to udev.packages, e.g.:
#   udev.packages = [ pkgs.rfkill_udev ];
#
# Add a hook script in the managed etc directory, e.g.:
#   etc = [
#     { source = pkgs.writeScript "rtfkill.hook" ''
#         #!/bin/sh
#
#         if [ "$RFKILL_STATE" -eq "1" ]; then
#           exec ${config.system.build.upstart}/sbin/initctl emit -n antenna-on
#         else
#           exec ${config.system.build.upstart}/sbin/initctl emit -n antenna-off
#         fi
#       '';
#       target = "rfkill.hook";
#     }

# Note: this package does not need the binaries
# in the rfkill package.

stdenv.mkDerivation {
  name = "rfkill-udev";

  unpackPhase = "true";
  dontBuild = true;

  installPhase = ''
    ensureDir "$out/etc/udev/rules.d/";
    cat > "$out/etc/udev/rules.d/90-rfkill.rules" << EOF
      SUBSYSTEM=="rfkill", ATTR{type}=="wlan", RUN+="$out/bin/rfkill-hook.sh" 
    EOF

    ensureDir "$out/bin/";
    cp ${./rfkill-hook.sh} "$out/bin/rfkill-hook.sh"
    chmod +x "$out/bin/rfkill-hook.sh";
  '';

  meta = {
    homepage = http://wireless.kernel.org/en/users/Documentation/rfkill;
    description = "Rules+hook for udev to catch rfkill state changes";
    platforms = stdenv.lib.platforms.linux;
  };
}