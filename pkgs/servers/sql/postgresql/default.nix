let
  mkPackages = self: {
    postgresql_12 = import ./12.nix {
      this = self.postgresql_12;
      thisAttr = "postgresql_12";
      inherit self;
    };

    postgresql_13 = import ./13.nix {
      this = self.postgresql_13;
      thisAttr = "postgresql_13";
      inherit self;
    };

    postgresql_14 = import ./14.nix {
      this = self.postgresql_14;
      thisAttr = "postgresql_14";
      inherit self;
    };

    postgresql_15 = import ./15.nix {
      this = self.postgresql_15;
      thisAttr = "postgresql_15";
      inherit self;
    };

    postgresql_16 = import ./16.nix {
      this = self.postgresql_16;
      thisAttr = "postgresql_16";
      inherit self;
    };
  };

in self:
  let packages = mkPackages self; in
  packages
  // self.lib.mapAttrs'
    (attrName: postgres: self.lib.nameValuePair "${attrName}_jit" (postgres.override rec {
      jitSupport = true;
      thisAttr = "${attrName}_jit";
      this = self.${thisAttr};
    }))
    packages
