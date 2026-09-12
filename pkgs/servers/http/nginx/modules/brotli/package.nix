{
  brotli,
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "brotli";
  version = "1.0.0rc-unstable-2022-04-29";

  src = fetchFromGitHub {
    owner = "google";
    repo = "ngx_brotli";
    rev = "6e975bcb015f62e1f303054897783355e2a877dc";
    hash = "sha256-G0IDYlvaQzzJ6cNTSGbfuOuSXFp3RsEwIJLGapTbDgo=";
  };

  postPatch = ''
    substituteInPlace filter/config \
      --replace-fail '$ngx_addon_dir/deps/brotli/c' ${lib.getDev brotli}
  '';

  buildInputs = [ brotli ];

  meta = {
    description = "Brotli compression";
    homepage = "https://github.com/google/ngx_brotli";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
