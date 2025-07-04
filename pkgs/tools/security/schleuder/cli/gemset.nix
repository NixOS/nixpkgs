{
  schleuder-cli = {
    dependencies = [ "thor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "fd010d28b1503504056e714e03abf043b64794ea";
      hash = "sha256-fVl+f2tz1C+Lg3SllrxuwxZdnOT5EAEIJoEB0ED0CuU=";
      type = "git";
      url = "https://0xacab.org/schleuder/schleuder-cli";
    };
    version = "0.2.0";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+n40cdT2onE449nJsNTarJw9c4OSdmeug+mrQq50Ae8=";
      type = "gem";
    };
    version = "1.3.1";
  };
}
