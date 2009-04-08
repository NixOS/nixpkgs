{pkgs, config, ...}:

###### implementation

{

  services = {
    extraJobs = [{
      name = "ctrl-alt-delete";
      
      job = ''
        on ctrlaltdel
        
        script
            shutdown -r now 'Ctrl-Alt-Delete pressed'
        end script
       '';
    }];
  };
}
