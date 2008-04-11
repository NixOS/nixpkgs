args : with args; 
rec {
  src = fetchurl {
    url = http://ftg.lbl.gov/CheckpointRestart/downloads/blcr-0.6.5.tar.gz ;
    sha256 = "195gwxb38wmhzxr0jr349g6pxlwz6id2y6szv2akprv5ypy9py0g";
  };

  buildInputs = [perl];
  configureFlags = [ 
    "--with-linux=$(ls -d ${kernel}/lib/modules/*/build)" 
    "--with-kmod-dir=$out/lib/modules/$(cd ${kernel}/lib/modules; ls -d 2.6.*)" 
    "--with-system-map=${kernel}/System.map"
  ];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "blcr-" + version;
  meta = {
    description = "Berkley Labs Checkpointing/Restarting module (save process tree state)";
  };
}
