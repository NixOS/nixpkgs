{stdenv}:
stdenv.mkDerivation {
  name = "hal-info-synaptics";
  buildCommand = ''
    mkdir -p $out/share/hal/fdi/information/15-osvendor/
    cat << EOF > $out/share/hal/fdi/information/15-osvendor/10-x11-synaptics.fdi
<?xml version="1.0" encoding="UTF-8"?>
       <deviceinfo version="0.2">
           <device>
               <match key="info.product" contains="Synaptics TouchPad">
                   <merge key="input.x11_driver" type="string">synaptics</merge>
                   <merge key="input.x11_options.AlwaysCore" type="string">true</merge>
                   <merge key="input.x11_options.Protocol" type="string">event</merge>
               </match>
           </device>
       </deviceinfo>
EOF
  '';
}
