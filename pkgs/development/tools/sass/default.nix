{ lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "sass-3.4.22";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Tools and Ruby libraries for the CSS3 extension languages: Sass and SCSS";
    homepage    = http://sass-lang.com/;
    license     = licenses.mit;
    maintainers = [ maintainers.romildo ];
    platforms   = platforms.unix;
  };
}
