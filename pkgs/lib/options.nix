let

  mkOption = attrs: attrs // {_type = "option";};

  typeOf = x: if x ? _type then x._type else "";


  combine = defs: opts: opts //
    builtins.listToAttrs (map (defName:
      { attr = defName;
        value = 
          let
            defValue = builtins.getAttr defName defs;
            optValue = builtins.getAttr defName opts;
          in
          if typeOf defValue == "option"
          then
            # `defValue' is an option.
            if builtins.hasAttr defName opts
            then builtins.getAttr defName opts
            else defValue.default
          else
            # `defValue' is an attribute set containing options.
            # So recurse.
            if builtins.hasAttr defName opts && builtins.isAttrs optValue 
            then combine defValue optValue
            else combine defValue {};
      }
    ) (builtins.attrNames defs));


  testDefs = {
  
    time = {
      timeZone = mkOption {
        default = "CET";
        example = "America/New_York";
        description = "The time zone used when displaying times and dates.";
      };
    };

    boot = {
      kernelModules = mkOption {
        default = ["mod1"];
        description = "
          The set of kernel modules to be loaded in the second stage of
          the boot process.  That is, these modules are not included in
          the initial ramdisk, so they'd better not be required for
          mounting the root file system.  Add them to
          <option>boot.initrd.extraKernelModules</option> if they are.
        ";
      };

      initrd = {
      
        kernelModules = mkOption {
          default = [
            "ahci"
            "ata_piix"
            "pata_marvell"
            "sd_mod"
            "sr_mod"
            "ide-cd"
            "ide-disk"
            "ide-generic"
            "ext3"
            # Support USB keyboards, in case the boot fails and we only have
            # a USB keyboard.
            "ehci_hcd"
            "ohci_hcd"
            "usbhid"
          ];
          description = "
            The set of kernel modules in the initial ramdisk used during the
            boot process.
          ";
        };
        
      };
      
    };
    
  };


  testOpts = {
    /*
    time = {
      timeZone = "UTC";
    };
    */
    boot = {
      initrd = {
        kernelModules = ["foo"];
        extraKernelModules = ["bar"];
      };
    };
  };

in (combine testDefs testOpts).boot.initrd.kernelModules
