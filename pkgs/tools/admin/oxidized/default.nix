{ lib, ruby, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "oxidized";
  gemdir = ./.;

  inherit ruby;

  exes = [ "oxidized" "oxidized-web" "oxidized-script" ];

  passthru.updateScript = bundlerUpdateScript "oxidized";

  meta = with lib; {
    description = "Oxidized is a network device configuration backup tool. It's a RANCID replacement!";
    homepage    = "https://github.com/ytti/oxidized";
    license     = licenses.asl20;
    maintainers = with maintainers; [ willibutz nicknovitski ];
    platforms   = platforms.linux;
  };
}
