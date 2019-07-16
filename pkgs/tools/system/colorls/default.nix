{ lib, bundlerApp, ruby, ... }:

bundlerApp rec {
  pname = "colorls";

  gemdir = ./.;
  exes = [ "colorls" ];

  meta = with lib; {
    description = "Prettified LS";
    homepage    = https://github.com/athityakumar/colorls;
    license     = with licenses; mit;
    maintainers = with maintainers; [ lukebfox ];
    platforms   = ruby.meta.platforms;
  };
}
