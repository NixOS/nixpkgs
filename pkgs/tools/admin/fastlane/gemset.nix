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
  babosa = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05rgxg4pz4bc4xk34w5grv0yp1j94wf571w84lf3xgqcbs42ip2f";
      type = "gem";
    };
    version = "1.0.2";
  };
  CFPropertyList = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06dddgcai6nay552h8wmnb2m93xx5hni48s16vkbf9vbym4nfw5x";
      type = "gem";
    };
    version = "2.3.5";
  };
  claide = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0az54rp691hc42yl1xyix2cxv58byhaaf4gxbpghvvq29l476rzc";
      type = "gem";
    };
    version = "1.0.2";
  };
  colored = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0x5jmsyi0z69bm6sij1k89z7h0laag3cb4mdn7zkl9qmxb90lx";
      type = "gem";
    };
    version = "1.2";
  };
  colored2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlbqa9q4mvrm73aw9mxh23ygzbjiqwisl32d8szfb5fxvbjng5i";
      type = "gem";
    };
    version = "3.1.2";
  };
  commander-fastlane = {
    dependencies = ["highline"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04gpg733wv878acvrzp4kc3k934v10l3v8bcz3fjq5imjsrjdnbp";
      type = "gem";
    };
    version = "4.4.5";
  };
  declarative = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0642xvwzzbgi3kp1bg467wma4g3xqrrn0sk369hjam7w579gnv5j";
      type = "gem";
    };
    version = "0.0.10";
  };
  declarative-option = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g4ibxq566f1frnhdymzi9hxxcm4g2gw4n21mpjk2mhwym4q6l0p";
      type = "gem";
    };
    version = "0.1.0";
  };
  domain_name = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12hs8yijhak7p2hf1xkh98g0mnp5phq3mrrhywzaxpwz1gw5r3kf";
      type = "gem";
    };
    version = "0.5.20170404";
  };
  dotenv = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pgzlvs0sswnqlgfm9gkz2hlhkc0zd3vnlp2vglb1wbgnx37pjjv";
      type = "gem";
    };
    version = "2.2.1";
  };
  excon = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mnc9lqlzwqj5ayp0lh7impisqm55mdg3mw5q4gi9yjic5sidc40";
      type = "gem";
    };
    version = "0.59.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gyqsj7vlqynwvivf9485zwmcj04v1z7gq362z0b8zw2zf4ag0hw";
      type = "gem";
    };
    version = "0.13.1";
  };
  faraday-cookie_jar = {
    dependencies = ["faraday" "http-cookie"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1di4gx6446a6zdkrpj679m5k515i53wvb4yxcsqvy8d8zacxiiv6";
      type = "gem";
    };
    version = "0.0.6";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p7icfl28nvl8qqdsngryz1snqic9l8x6bk0dxd7ygn230y0k41d";
      type = "gem";
    };
    version = "0.12.2";
  };
  fastimage = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fh80nwjxm63phcdg55haz9q877fxgvnkazjihaqbf8ginn6g00v";
      type = "gem";
    };
    version = "2.1.0";
  };
  fastlane = {
    dependencies = ["CFPropertyList" "addressable" "babosa" "colored" "commander-fastlane" "dotenv" "excon" "faraday" "faraday-cookie_jar" "faraday_middleware" "fastimage" "gh_inspector" "google-api-client" "highline" "json" "mini_magick" "multi_json" "multi_xml" "multipart-post" "plist" "public_suffix" "rubyzip" "security" "slack-notifier" "terminal-notifier" "terminal-table" "tty-screen" "word_wrap" "xcodeproj" "xcpretty" "xcpretty-travis-formatter"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1al75bb3zq0y9r1ilrbhks198zmvwykmqnn2675jd9i2ijcbxv78";
      type = "gem";
    };
    version = "2.63.0";
  };
  gh_inspector = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lxvp8xpjd2cazzcp90phy567spp4v41bnk9awgx8absndv70k1x";
      type = "gem";
    };
    version = "1.0.3";
  };
  google-api-client = {
    dependencies = ["addressable" "googleauth" "httpclient" "mime-types" "representable" "retriable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ac9qa0kwnirkvwz2w9zf07lqcgbmnvgd1wg8xxyjbadwsbpyf1y";
      type = "gem";
    };
    version = "0.13.6";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "logging" "memoist" "multi_json" "os" "signet"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13laklpf99m3qzq9n3vnc9dblgw7q05n1r16jlxsh4lxlaijr0sf";
      type = "gem";
    };
    version = "0.6.1";
  };
  highline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nf5lgdn6ni2lpfdn4gk3gi47fmnca2bdirabbjbz1fk9w4p8lkr";
      type = "gem";
    };
    version = "1.7.8";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  httpclient = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  jwt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w0kaqrbl71cq9sbnixc20x5lqah3hs2i93xmhlfdg2y3by7yzky";
      type = "gem";
    };
    version = "2.1.0";
  };
  little-plugger = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  logging = {
    dependencies = ["little-plugger" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06j6iaj89h9jhkx1x3hlswqrfnqds8br05xb1qra69dpvbdmjcwn";
      type = "gem";
    };
    version = "2.2.2";
  };
  memoist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pq8fhqh8w25qcw9v3vzfb0i6jp0k3949ahxc3wrwz2791dpbgbh";
      type = "gem";
    };
    version = "0.16.0";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
  };
  mini_magick = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a59k5l29vj060yscaqk370rg5vyr132kbw6x3zar7khzjqjqd8p";
      type = "gem";
    };
    version = "4.5.1";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1raim9ddjh672m32psaa9niw67ywzjbxbdb8iijx3wv9k5b0pk2x";
      type = "gem";
    };
    version = "1.12.2";
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
  nanaimo = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z6rbji02x75vm5jw4hbpp75khp4z5yfgbaz1h9l8aa00hqf0fxd";
      type = "gem";
    };
    version = "0.2.3";
  };
  os = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1llv8w3g2jwggdxr5a5cjkrnbbfnvai3vxacxxc0fy84xmz3hymz";
      type = "gem";
    };
    version = "0.9.6";
  };
  plist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k0pyqrjcz9kn1b3ahsfs9aqym7s7yzz0vavya0zn0mca3jw2zqc";
      type = "gem";
    };
    version = "3.3.0";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "040jf98jpp6w140ghkhw2hvc1qx41zvywx5gj7r2ylr1148qnj7q";
      type = "gem";
    };
    version = "2.0.5";
  };
  representable = {
    dependencies = ["declarative" "declarative-option" "uber"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qm9rgi1j5a6nv726ka4mmixivlxfsg91h8rpp72wwd4vqbkkm07";
      type = "gem";
    };
    version = "3.0.4";
  };
  retriable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pnriyn9zh120hxm92vb12hfsf7c98nawyims1shxj3ldpl0l3ar";
      type = "gem";
    };
    version = "3.1.1";
  };
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sfikq1q8xyqqx690iiz7ybhzx87am4w50w8f2nq36l3asw4x89d";
      type = "gem";
    };
    version = "2.0.7";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06js4gznzgh8ac2ldvmjcmg9v1vg9llm357yckkpylaj6z456zqz";
      type = "gem";
    };
    version = "1.2.1";
  };
  security = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ryjxs0j66wrbky2c08yf0mllwalvpg12rpxzbdx2rdhj3cbrlxa";
      type = "gem";
    };
    version = "0.1.3";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0js81lxqirdza8gf2f6avh11fny49ygmxfi1qx7jp8l9wrhznbkv";
      type = "gem";
    };
    version = "0.8.1";
  };
  slack-notifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xavibxh00gy62mm79l6id9l2fldjmdqifk8alqfqy5z38ffwah6";
      type = "gem";
    };
    version = "1.5.1";
  };
  terminal-notifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vy75sbq236v1p83jj6r3a9d52za5lqj2vj24np9lrszdczm9zcb";
      type = "gem";
    };
    version = "1.8.0";
  };
  terminal-table = {
    dependencies = ["unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1512cngw35hsmhvw4c05rscihc59mnj09m249sm9p3pik831ydqk";
      type = "gem";
    };
    version = "1.8.0";
  };
  tty-screen = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12qkjwpkgznvhwbywq2y7l5mcq2f4z404b0ip7xm4byg3827lh4h";
      type = "gem";
    };
    version = "0.5.1";
  };
  uber = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    version = "0.1.0";
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14hr2dzqh33kqc0xchs8l05pf3kjcayvad4z1ip5rdjxrkfk8glb";
      type = "gem";
    };
    version = "0.0.7.4";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12pi0gwqdnbx1lv5136v3vyr0img9wr0kxcn4wn54ipq4y41zxq8";
      type = "gem";
    };
    version = "1.3.0";
  };
  word_wrap = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iyc5bc7dbgsd8j3yk1i99ral39f23l6wapi0083fbl19hid8mpm";
      type = "gem";
    };
    version = "1.0.0";
  };
  xcodeproj = {
    dependencies = ["CFPropertyList" "claide" "colored2" "nanaimo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gvnd5ixa4wbn1cpc6jp6i9z0dxhcwlxny47irzbr6zr8wpj3ww7";
      type = "gem";
    };
    version = "1.5.3";
  };
  xcpretty = {
    dependencies = ["rouge"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b8x9m53a1hbw0lamffjm4m1ydigj3azl97jc5w7prv1bm27s2y3";
      type = "gem";
    };
    version = "0.2.8";
  };
  xcpretty-travis-formatter = {
    dependencies = ["xcpretty"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15b5c0lxz2blmichfdlabzlbyw5nlh1ci898pxwb661m9bahz3ml";
      type = "gem";
    };
    version = "1.0.0";
  };
}