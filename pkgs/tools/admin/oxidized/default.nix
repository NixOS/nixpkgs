{ lib, fetchFromGitHub, ruby, git, bundlerApp }:

bundlerApp rec {
  pname = "oxidized";
  gemdir = ./.;

  inherit ruby;

  exes = [ "oxidized" "oxidized-web" "oxidized-script" ];

  meta = with lib; {
    description = "Oxidized is a network device configuration backup tool. It's a RANCID replacement!";
    homepage    = https://github.com/ytti/oxidized;
    license     = licenses.asl20;
    maintainers = [ maintainers.willibutz ];
    platforms   = platforms.linux;
  };
}
