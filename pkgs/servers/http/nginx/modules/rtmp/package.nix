{
  lib,
  fetchFromGitHub,
  fetchpatch,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "rtmp";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "arut";
    repo = "nginx-rtmp-module";
    tag = "v${finalAttrs.version}";
    sha256 = "0y45bswk213yhkc2v1xca2rnsxrhx8v6azxz9pvi71vvxcggqv6h";
  };

  patches = [
    # GCC 16's improved unused variable analysis detects some unused
    # variables which were fixed upstream but not released.
    (fetchpatch {
      name = "remove-unused-variables-ngx-rtmp-handler.patch";
      url = "https://github.com/arut/nginx-rtmp-module/commit/6c7719d0ba32e00b563ec70bd43dad11960fa9c4.patch";
      hash = "sha256-c2hSp4CamBYMwkU9EOUSnfXvCYVOIxm1WzMR/M7Ojcc=";
    })
    (fetchpatch {
      name = "remove-unused-variables-ngx-rtmp-eval.patch";
      url = "https://github.com/arut/nginx-rtmp-module/commit/c56fd73def3eb407155ecebc28af84ea83dc99e5.patch";
      hash = "sha256-APXdEsRp3SSUKM9ud8tbZEPsfOe/055TRD7FFHE2k9w=";
    })
  ];

  meta = {
    description = "Media Streaming Server";
    homepage = "https://github.com/arut/nginx-rtmp-module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
