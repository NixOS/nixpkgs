let

  fetch = { file, sha256 }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-linux/loongson2f/r22849/${file}";
    inherit sha256;
    executable = true;
  };

in {
  sh = fetch {
    file = "sh";
    sha256 = "02jjl49wdq85pgh61aqf78yaknn9mi3rcspbpk7hs9c4mida2rhf";
  };

  bzip2 = fetch {
    file = "bzip2";
    sha256 = "1qn27y3amj9c6mnjk2kyb59y0d2w4yv16z9apaxx91hyq19gf29z";
  };

  mkdir = fetch {
    file = "mkdir";
    sha256 = "1vbp2bv9hkyb2fwl8hjrffpywn1wrl1kc4yrwi2lirawlnc6kymh";
  };

  cpio = fetch {
    file = "cpio";
    sha256 = "0mqxwdx0sl7skxx6049mk35l7d0fnibqsv174284kdp4p7iixwa0";
  };

  ln = fetch {
    file = "ln";
    sha256 = "05lwx8qvga3yv8xhs8bjgsfygsfrcxsfck0lxw6gsdckx25fgi7s";
  };

  curl = fetch {
    file = "curl.bz2";
    sha256 = "0iblnz4my54gryac04i64fn3ksi9g3dx96yjq93fj39z6kx6151c";
  };

  bootstrapTools = {
    url = "http://tarballs.nixos.org/stdenv-linux/loongson2f/r22849/cross-bootstrap-tools.cpio.bz2";
    sha256 = "00aavbk76qjj2gdlmpaaj66r8nzl4d7pyl8cv1gigyzgpbr5vv3j";
  };
}
