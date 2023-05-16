{ lib, buildManPages }:

buildManPages {
  pname = "s6-portable-utils-man-pages";
<<<<<<< HEAD
  version = "2.3.0.2.2";
  sha256 = "0zbxr6jqrx53z1gzfr31nm78wjfmyjvjx7216l527nxl9zn8nnv1";
=======
  version = "2.2.5.1.1";
  sha256 = "5up4IfsoHJGYwnDJVnnPWU9sSWS6qq+/6ICtHYjI6pg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  description = "Port of the documentation for the s6-portable-utils suite to mdoc";
  maintainers = [ lib.maintainers.somasis ];
}
