{
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  descendants_tracker = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    version = "0.0.4";
  };
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "157c4cmb5g1b3ny6k9qf9z57rfijl54fcq3hnqqf6g31g1m096b2";
      type = "gem";
    };
    version = "0.12.2";
  };
  github_api = {
    dependencies = ["addressable" "descendants_tracker" "faraday" "hashie" "oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04x8mlvinl17wfw6r71c9jbh7g78ziiwvsqv20ylyjzybr7x0w6s";
      type = "gem";
    };
    version = "0.18.2";
  };
  github_cli = {
    dependencies = ["github_api" "tty"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xd4waq2yq4ywx6vqyyr60hzh6jkibax8v61ndyk6mz904p9cf77";
      type = "gem";
    };
    version = "0.6.2";
  };
  hashie = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hh5lybf8hm7d7xs4xm8hxvm8xqrs2flc8fnwkrclaj746izw6xb";
      type = "gem";
    };
    version = "3.5.7";
  };
  jwt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "124zz1142bi2if7hl5pcrcamwchv4icyr5kaal9m2q6wqbdl6aw4";
      type = "gem";
    };
    version = "1.5.6";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  multi_xml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lmd4f401mvravi1i1yq7b2qjjli0yq7dfc4p1nj5nwajp7r6hyj";
      type = "gem";
    };
    version = "0.6.0";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_json" "multi_xml" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "094hmmfms8vpm6nwglpl7jmlv85nlfzl0kik4fizgx1rg70a6mr5";
      type = "gem";
    };
    version = "1.4.0";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x5h1dh1i3gwc01jbg01rly2g6a1qwhynb1s8a30ic507z1nh09s";
      type = "gem";
    };
    version = "3.0.2";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "158hbn7rlc3czp2vivvam44dv6vmzz16qrh5dbzhfxbfsgiyrqw1";
      type = "gem";
    };
    version = "2.0.5";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tty = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x1zw00xfmv33g02b1f5i0g71z07gh82ql2iacxy2d2s098cazi3";
      type = "gem";
    };
    version = "0.0.11";
  };
}