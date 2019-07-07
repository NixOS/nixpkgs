{ lib, bundlerApp }:

bundlerApp {
  pname = "sass";
  gemdir = ./.;
  exes = [ "sass" "sass-convert" "scss" ];

  meta = with lib; {
    description = "Tools and Ruby libraries for the CSS3 extension languages: Sass and SCSS";
    homepage    = https://sass-lang.com;
    license     = licenses.mit;
    maintainers = with maintainers; [ romildo manveru ];
    platforms   = platforms.unix;
  };
}
