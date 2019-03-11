{ lib, ruby, bundlerApp }:

bundlerApp {
  pname = "docker-sync";
  gemdir = ./.;

  inherit ruby;

  exes = ["docker-sync"];

  meta = with lib; {
    description = "Run your application at full speed while syncing your code for development";
    homepage = http://docker-sync.io;
    license = licenses.gpl3;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
