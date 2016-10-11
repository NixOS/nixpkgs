{ lib
# toolchain supported flags
, hardeningSupported
# package level flags
, hardeningEnable, hardeningDisable
}:
let
inherit (builtins) filter map elem;
inherit (lib) getAttr concatMap flip;

# mapping from nixpkgs hardening flags to their compiler / linker meanings
hardeningFlagMap = {
  bindnow = {
    LD = [ "-z" "now" ];
  };
  format = {
    C = [ "-Wformat" "-Wformat-security" "-Werror=format-security" ];
  };
  fortify = {
    C = [ "-O2" "-D_FORTIFY_SOURCE=2" ];
  };
  pie = {
    C = [ "-fPIE" ];
    LD = [ "-pie" ];
  };
  pic = {
    C = [ "-fPIC" ];
  };
  relro = {
    LD = [ "-z" "relro" ];
  };
  stackprotector = {
    C = [ "-fstack-protector-strong" "--param ssp-buffer-size=4" ];
  };
  strictoverflow = {
    C = [ "-fno-strict-overflow" ];
  };
};

# filter out disabled flags
enabledFlags = filter (x: ! elem x hardeningDisable) hardeningEnable;

# filter out unsupported flags
supportedEnabledFlags = filter (flip elem hardeningSupported) enabledFlags;

enabledFlagsMap = map (flip getAttr hardeningFlagMap) supportedEnabledFlags;

in {
  hardeningCFlags = concatMap (x: x.C or []) enabledFlagsMap;
  hardeningLDFlags = concatMap (x: x.LD or []) enabledFlagsMap;
}
