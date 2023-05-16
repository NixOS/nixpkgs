{ callPackage
<<<<<<< HEAD
, nginxMainline
=======
, fetchhg
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ...
} @ args:

callPackage ./generic.nix args {
  pname = "nginxQuic";

<<<<<<< HEAD
  inherit (nginxMainline) src version;

  configureFlags = [
    "--with-http_v3_module"
  ];
=======
  src = fetchhg {
    url = "https://hg.nginx.org/nginx-quic";
    rev = "0af598651e33"; # branch=quic
    hash = "sha256-rG0jXA+ci7anUxZCBhXZLZKwnTtzzDEAViuoImKpALA=";
  };

  preConfigure = ''
    ln -s auto/configure configure
  '';

  configureFlags = [
    "--with-http_v3_module"
    "--with-stream_quic_module"
  ];

  version = "1.23.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
