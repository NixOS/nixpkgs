{stdenv, fetchurl}: stdenv.mkDerivation ({
  name = "gnupatch-2.5.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/patch-2.5.4.tar.gz;
    md5 = "ee5ae84d115f051d87fcaaef3b4ae782";
  };
} // 
  # !!! hack
  (if stdenv.system != "i686-linux" then {
    patches = [./setmode.patch];
    configureFlags = "dummy"; # doesn't build on Darwin unless a platform is specified
  } else {})
  // 
  # !!! hack
  (if stdenv ? isDietLibC then {
    # !!! pass this on all platforms
    configureFlags = "dummy"; # doesn't build unless a platform is specified
  } else {})
)
