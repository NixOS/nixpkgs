{
  chunky_png = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "124najs9prqzrzk49h53kap992rmqxj0wni61z2hhsn7mwmgdp9d";
      type = "gem";
    };
    version = "1.3.11";
  };
  compass = {
    dependencies = ["chunky_png" "compass-core" "compass-import-once" "rb-fsevent" "rb-inotify" "sass"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lfi83w8z75czr0pf0rmj9hda22082h3cmvczl8r1ma9agf88y2c";
      type = "gem";
    };
    version = "1.0.3";
  };
  compass-core = {
    dependencies = ["multi_json" "sass"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yaspqwdmzwdcqviclbs3blq7an16pysrfzylz8q1gxmmd6bpj3a";
      type = "gem";
    };
    version = "1.0.3";
  };
  compass-import-once = {
    dependencies = ["sass"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bn7gwbfz7jvvdd0qdfqlx67fcb83gyvxqc7dr9fhcnks3z8z5rq";
      type = "gem";
    };
    version = "1.0.5";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j8pzj8raxbir5w5k6s7a042sb5k02pg0f8s4na1r5lan901j00p";
      type = "gem";
    };
    version = "1.10.0";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  rb-fsevent = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lm1k7wpz69jx7jrc92w3ggczkjyjbfziq5mg62vjnxmzs383xx8";
      type = "gem";
    };
    version = "0.10.3";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fs7hxm9g6ywv2yih83b879klhc4fs8i0p9166z795qmd77dk0a4";
      type = "gem";
    };
    version = "0.10.0";
  };
  sass = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kfpcwh8dgw4lc81qglkvjl73689jy3g7196zkxm4fpskg1p5lkw";
      type = "gem";
    };
    version = "3.4.25";
  };
}