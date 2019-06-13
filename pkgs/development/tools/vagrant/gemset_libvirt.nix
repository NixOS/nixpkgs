{
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15l9w0938c19nxmrp09n75qpmm64k12xj69h47yvxzcxcpbgnkb2";
      type = "gem";
    };
    version = "0.62.0";
  };
  fog-core = {
    dependencies = ["builder" "excon" "formatador"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ac25s2wv7m6av7h7vjzd2bg3srhnn5yrz3lq1xpimhnfmp82sw6";
      type = "gem";
    };
    version = "1.43.0";
  };
  fog-json = {
    dependencies = ["fog-core" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj8llzc119zafbmfa4ai3z5s7c4vp9akfs0f9l2piyvcarmlkyx";
      type = "gem";
    };
    version = "1.2.0";
  };
  fog-libvirt = {
    dependencies = ["fog-core" "fog-json" "fog-xml" "json" "ruby-libvirt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gk16gsjd51x71wla7h5jqr6x5ywpwz5l8jdv76f9mr6fp1j2bkf";
      type = "gem";
    };
    version = "0.5.0";
  };
  fog-xml = {
    dependencies = ["fog-core" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "043lwdw2wsi6d55ifk0w3izi5l1d1h0alwyr3fixic7b94kc812n";
      type = "gem";
    };
    version = "0.1.3";
  };
  formatador = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gc26phrwlmlqrmz4bagq1wd5b7g64avpx0ghxr9xdxcvmlii0l0";
      type = "gem";
    };
    version = "0.2.5";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byyxrazkfm29ypcx5q4syrv126nvjnf7z6bqi01sqkv4llsi4qz";
      type = "gem";
    };
    version = "1.8.5";
  };
  ruby-libvirt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d754d6pgdqyq52pl9hp0x38q1vn3vf9nz4nm5gqdj5i4fw7pba6";
      type = "gem";
    };
    version = "0.7.1";
  };
  vagrant-libvirt = {
    dependencies = ["fog-core" "fog-libvirt" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wm5yvml3sxdzpnlp4q6yhy695syy8byd1g7cxll4pmj1kwlknym";
      type = "gem";
    };
    version = "0.0.45";
  };
}
