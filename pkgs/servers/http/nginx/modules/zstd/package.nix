{
  fetchFromGitHub,
  fetchpatch,
  lib,
  mkNginxPlugin,
  zstd,
}:

mkNginxPlugin (finalAttrs: {
  pname = "zstd";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tokers";
    repo = "zstd-nginx-module";
    tag = finalAttrs.version;
    hash = "sha256-1gCV7uUsuYnZfb9e8VfjWkUloVINOUH5qzeJ03kIHgs=";
  };

  patches = [
    (fetchpatch {
      name = "fix-module-order.patch";
      url = "https://github.com/tokers/zstd-nginx-module/commit/f4ba115e0b0eaecde545e5f37db6aa18917d8f4b.patch";
      hash = "sha256-QCd/oBqAAdKpze903Cd119I+FSVYoEW+j38Hhg45hL8=";
    })
  ];

  buildInputs = [ zstd ];

  meta = {
    description = "Nginx modules for the Zstandard compression";
    homepage = "https://github.com/tokers/zstd-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
