{pkgs, config, ...}:

###### implementation

let

  tempConf = "/var/run/mdadm.conf";
  modprobe = config.system.sbin.modprobe;
  inherit (pkgs) mdadm;

in
  
{

  services = {
    extraJobs = [{
      name = "swraid";
      
      job = ''
      start on udev
      #start on new-devices
      
      script
      
          # Load the necessary RAID personalities.
          # !!! hm, doesn't the kernel load these automatically?
          for mod in raid0 raid1 raid5; do
              ${modprobe}/sbin/modprobe $mod || true
          done
      
          # Scan /proc/partitions for RAID devices.
          ${mdadm}/sbin/mdadm --examine --brief --scan -c partitions > ${tempConf}
      
          # Activate each device found.
          ${mdadm}/sbin/mdadm --assemble -c ${tempConf} --scan
      
          initctl emit new-devices
          
      end script
      
      '';
    }];
  };
}
