{ services.xserver.enable = true;

  # Automatically log in.
  services.xserver.displayManager.slim.enable = false;
  services.xserver.displayManager.auto.enable = true;

  # Use IceWM as the window manager.
  services.xserver.windowManager.default = "icewm";
  services.xserver.windowManager.icewm.enable = true;

  # Don't use a desktop manager.
  services.xserver.desktopManager.default = "none";
}
