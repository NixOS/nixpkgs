args:
(import ./meta.nix)
( args //
  {
    version = "2.6.23";
    src_hash = { sha256 = "1nyv7004w40l4adzq2b0hrvk3f4iqwngkgrlh8as9cpz6l4prrnl"; };

	systemPatches = [ ];

    config = with args;
      if config != null then config else
      if userModeLinux then ./config-2.6.23.1-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.23.1-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.23.1-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }
)
