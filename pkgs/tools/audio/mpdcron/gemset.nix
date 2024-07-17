{
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  nokogiri = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02bjydih0j515szfv9mls195cvpyidh6ixm7dwbl3s2sbaxxk5s4";
      type = "gem";
    };

    dontBuild = false;
    patches = [
      # Fixes a naming conflict of nokogiri's `canonicalize` function
      # with one defined in glibc. This has been fixed upstream in 2020
      # in a much newer version (1.15.5), but through the divergence
      # of the affected file, the commit isn't directly applicable to
      # the one packaged here:
      #
      # https://github.com/sparklemotion/nokogiri/pull/2106/commits/7a74cdbe4538e964023e5a0fdca58d8af708b91e
      # https://github.com/sparklemotion/nokogiri/issues/2105
      ./fix-canonicalize-conflict-with-glibc.patch
    ];
    version = "1.10.3";
  };
}
