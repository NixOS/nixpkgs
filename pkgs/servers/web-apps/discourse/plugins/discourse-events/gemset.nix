{
  discourse_subscription_client = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13vmi645ilsqjalz04738d8ng9zxhw5nd5s80lwcdd87dpzmkk3v";
      type = "gem";
    };
    version = "0.1.11";
  };
  icalendar = {
    dependencies = [ "ice_cube" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11zfs0l8y2a6gpf0krm91d0ap2mnf04qky89dyzxwaspqxqgj174";
      type = "gem";
    };
    version = "2.8.0";
  };
  icalendar-recurrence = {
    dependencies = [
      "icalendar"
      "ice_cube"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06li3cdbwkd9y2sadjlbwj54blqdaa056yx338s4ddfxywrngigh";
      type = "gem";
    };
    version = "1.1.3";
  };
  ice_cube = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dri4mcya1fwzrr9nzic8hj1jr28a2szjag63f9k7p2bw9fpw4fs";
      type = "gem";
    };
    version = "0.16.4";
  };
  iso-639 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k1r8wgk6syvpsl3j5qfh5az5w4zdvk0pvpjl7qspznfdbp2mn71";
      type = "gem";
    };
    version = "0.3.5";
  };
}
