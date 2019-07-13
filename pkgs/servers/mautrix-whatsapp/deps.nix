# NOTE: this file isn't entirely generated, while performing the bump
# from 2019-02-24 to 2019-06-01, a lot of stuff broke during `vgo2nix` as the
# tool is unable to parse `replace` statements atm.
#
# The following sources were altered manually:
# * github.com/Rhymen/go-whatsapp -> github.com/tulir/go-whatsapp (at 36ed380bdc18)
# * github.com/golang/protobuf: v1.2.0 -> v1.3.1
# * maunium.net/go/mautrix: v0.1.0-alpha3 -> ca5d9535b6cc
# * maunium.net/go/mautrix-appservice: v0.1.0-alpha3 -> 6e6c9bb47548

# file generated from go.mod using vgo2nix (https://github.com/adisbladis/vgo2nix)
[
  {
    goPackagePath = "github.com/Rhymen/go-whatsapp";
    fetch = {
      type = "git";
      url = "https://github.com/tulir/go-whatsapp";
      rev = "36ed380bdc188e35fe804d6dd4809ee170136670";
      sha256 = "1ida4j5hgqc5djwfsaqp8g6iynn150rwj42kqk9q2srwz5075n4p";
    };
  }
  {
    goPackagePath = "github.com/fatih/color";
    fetch = {
      type = "git";
      url = "https://github.com/fatih/color";
      rev = "v1.7.0";
      sha256 = "0v8msvg38r8d1iiq2i5r4xyfx0invhc941kjrsg5gzwvagv55inv";
    };
  }
  {
    goPackagePath = "github.com/golang/protobuf";
    fetch = {
      type = "git";
      url = "https://github.com/golang/protobuf";
      rev = "v1.3.1";
      sha256 = "15am4s4646qy6iv0g3kkqq52rzykqjhm4bf08dk0fy2r58knpsyl";
    };
  }
  {
    goPackagePath = "github.com/gorilla/mux";
    fetch = {
      type = "git";
      url = "https://github.com/gorilla/mux";
      rev = "v1.6.2";
      sha256 = "0pvzm23hklxysspnz52mih6h1q74vfrdhjfm1l3sa9r8hhqmmld2";
    };
  }
  {
    goPackagePath = "github.com/gorilla/websocket";
    fetch = {
      type = "git";
      url = "https://github.com/gorilla/websocket";
      rev = "v1.4.0";
      sha256 = "00i4vb31nsfkzzk7swvx3i75r2d960js3dri1875vypk3v2s0pzk";
    };
  }
  {
    goPackagePath = "github.com/lib/pq";
    fetch = {
      type = "git";
      url = "https://github.com/lib/pq";
      rev = "v1.1.1";
      sha256 = "0g64wlg1l1ybq4x44idksl4pgm055s58jxc6r6x4qhqm5q76h0km";
    };
  }
  {
    goPackagePath = "github.com/mattn/go-colorable";
    fetch = {
      type = "git";
      url = "https://github.com/mattn/go-colorable";
      rev = "v0.0.9";
      sha256 = "1nwjmsppsjicr7anq8na6md7b1z84l9ppnlr045hhxjvbkqwalvx";
    };
  }
  {
    goPackagePath = "github.com/mattn/go-isatty";
    fetch = {
      type = "git";
      url = "https://github.com/mattn/go-isatty";
      rev = "v0.0.4";
      sha256 = "0zs92j2cqaw9j8qx1sdxpv3ap0rgbs0vrvi72m40mg8aa36gd39w";
    };
  }
  {
    goPackagePath = "github.com/mattn/go-sqlite3";
    fetch = {
      type = "git";
      url = "https://github.com/mattn/go-sqlite3";
      rev = "v1.10.0";
      sha256 = "1zmz6asplixfihxhj11spgfs0v3xzb3nv0hlq6n6zsg781ni31xx";
    };
  }
  {
    goPackagePath = "github.com/pkg/errors";
    fetch = {
      type = "git";
      url = "https://github.com/pkg/errors";
      rev = "v0.8.1";
      sha256 = "0g5qcb4d4fd96midz0zdk8b9kz8xkzwfa8kr1cliqbg8sxsy5vd1";
    };
  }
  {
    goPackagePath = "gopkg.in/russross/blackfriday.v2";
    fetch = {
      type = "git";
      url = "https://github.com/russross/blackfriday";
      rev = "v2.0.1";
      sha256 = "0nlz7isdd4rgnwzs68499hlwicxz34j2k2a0b8jy0y7ycd2bcr5j";
    };
  }
  {
    goPackagePath = "github.com/shurcooL/sanitized_anchor_name";
    fetch = {
      type = "git";
      url = "https://github.com/shurcooL/sanitized_anchor_name";
      rev = "v1.0.0";
      sha256 = "1gv9p2nr46z80dnfjsklc6zxbgk96349sdsxjz05f3z6wb6m5l8f";
    };
  }
  {
    goPackagePath = "github.com/skip2/go-qrcode";
    fetch = {
      type = "git";
      url = "https://github.com/skip2/go-qrcode";
      rev = "dc11ecdae0a9";
      sha256 = "0mc70hsn5x2a66a9sbwlq51cng2s1aq7rw4pr9pif4xdzflkl057";
    };
  }
  {
    goPackagePath = "golang.org/x/crypto";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/crypto";
      rev = "b8fe1690c613";
      sha256 = "1mbfpbrirsz8fsdkibm9l4sccpm774p9201mpmfh4hxshz3girq3";
    };
  }
  {
    goPackagePath = "golang.org/x/net";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/net";
      rev = "915654e7eabc";
      sha256 = "0fzd7n2yc4qnnf2wk21zxy6gb01xviq2z1dzrbqcn8p1s4fjsqw5";
    };
  }
  {
    goPackagePath = "golang.org/x/sync";
    fetch = {
      type = "git";
      url = "https://go.googlesource.com/sync";
      rev = "37e7f081c4d4";
      sha256 = "1bb0mw6ckb1k7z8v3iil2qlqwfj408fvvp8m1cik2b46p7snyjhm";
    };
  }
  {
    goPackagePath = "gopkg.in/check.v1";
    fetch = {
      type = "git";
      url = "https://gopkg.in/check.v1";
      rev = "788fd7840127";
      sha256 = "0v3bim0j375z81zrpr5qv42knqs0y2qv2vkjiqi5axvb78slki1a";
    };
  }
  {
    goPackagePath = "gopkg.in/yaml.v2";
    fetch = {
      type = "git";
      url = "https://gopkg.in/yaml.v2";
      rev = "v2.2.2";
      sha256 = "01wj12jzsdqlnidpyjssmj0r4yavlqy7dwrg7adqd8dicjc4ncsa";
    };
  }
  {
    goPackagePath = "maunium.net/go/mauflag";
    fetch = {
      type = "git";
      url = "https://github.com/tulir/mauflag.git";
      rev = "v1.0.0";
      sha256 = "09jv1819jwq5i29y6ngf4j4ii6qwlshydvprfvsfplc419dkz1vx";
    };
  }
  {
    goPackagePath = "maunium.net/go/maulogger";
    fetch = {
      type = "git";
      url = "https://github.com/tulir/maulogger.git";
      rev = "v2.0.0";
      sha256 = "0qz4cpaqvcmrj3fb2bb6yrhw3k5h51crskricyqgg1b7aklphan5";
    };
  }
  {
    goPackagePath = "maunium.net/go/mautrix";
    fetch = {
      type = "git";
      url = "https://github.com/tulir/mautrix-go.git";
      rev = "ca5d9535b6ccee8fdf473f9cc935932ef3e53ae7";
      sha256 = "1qrh77c8vh2k6ffwf0cymjmhcp7d0rdad1ixqx5r1xig27f7v0qg";
    };
  }
  {
    goPackagePath = "maunium.net/go/mautrix-appservice";
    fetch = {
      type = "git";
      url = "https://github.com/tulir/mautrix-appservice-go.git";
      rev = "6e6c9bb4754849443cb3c64d9510f8d2eb3e668d";
      sha256 = "1zwsfvgxs2zbc6yvgnk16w2wkh891kihrzar3qzz9cvsgjznlyvy";
    };
  }
]
