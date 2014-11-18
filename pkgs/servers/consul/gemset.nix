{
  execjs = {
    version = "2.0.2";
    src = {
      type = "gem";
      sha256 = "167kbkyql7nvvwjsgdw5z8j66ngq7kc59gxfwsxhqi5fl1z0jbjs";
    };
  };
  json = {
    version = "1.8.1";
    src = {
      type = "gem";
      sha256 = "0002bsycvizvkmk1jyv8px1hskk6wrjfk4f7x5byi8gxm6zzn6wn";
    };
  };
  libv8 = {
    version = "3.16.14.3";
    src = {
      type = "gem";
      sha256 = "1arjjbmr9zxkyv6pdrihsz1p5cadzmx8308vgfvrhm380ccgridm";
    };
  };
  ref = {
    version = "1.0.5";
    src = {
      type = "gem";
      sha256 = "19qgpsfszwc2sfh6wixgky5agn831qq8ap854i1jqqhy1zsci3la";
    };
  };
  sass = {
    version = "3.3.6";
    src = {
      type = "gem";
      sha256 = "0ra0kxx52cgyrq6db7a1vysk984ilshbx40bcf527k8b3fha6k5r";
    };
  };
  therubyracer = {
    version = "0.12.1";
    src = {
      type = "gem";
      sha256 = "106fqimqyaalh7p6czbl5m2j69z8gv7cm10mjb8bbb2p2vlmqmi6";
    };
    dependencies = [
      "libv8"
      "ref"
    ];
  };
  uglifier = {
    version = "2.5.0";
    src = {
      type = "gem";
      sha256 = "0b9kxgyg8cv3g1bp6casndfzfy71jd9xyjxwng0lj90vzqrgjp20";
    };
    dependencies = [
      "execjs"
      "json"
    ];
  };
}