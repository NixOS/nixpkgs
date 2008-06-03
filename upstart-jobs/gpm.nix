{gpm, gpmConfig}:

let 
  gpmBin = "${gpm}/sbin/gpm";

in
{
  name = "gpm";
  job = ''
    description = "General purpose mouse"

    start on udev
    stop on shutdown

    respawn ${gpmBin} -m /dev/input/mice -t ${gpmConfig.protocol} -D &>/dev/null
  '';
}
