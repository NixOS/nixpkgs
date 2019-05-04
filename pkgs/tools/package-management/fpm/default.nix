{ lib, bundlerApp }:

bundlerApp {
  pname = "fpm";
  gemdir = ./.;
  exes = [ "fpm" ];

  meta = with lib; {
    description = "Tool to build packages for multiple platforms with ease";
    homepage    = https://github.com/jordansissel/fpm;
    license     = licenses.mit;
    maintainers = with maintainers; [ manveru ];
    platforms   = platforms.unix;
  };
}
