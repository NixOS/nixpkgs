{
  brotli,
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "brotli";
  version = "1.0.0rc-unstable-2023-10-09";

  src = fetchFromGitHub {
    owner = "google";
    repo = "ngx_brotli";
    rev = "a71f9312c2deb28875acc7bacfdd5695a111aa53";
    hash = "sha256-5XSEqXyaIKoUzs1OC6WGPwqpx8JWaE0aMlfjvOoYs3U=";
  };

  postPatch = ''
    substituteInPlace filter/config \
      --replace-fail '$ngx_addon_dir/deps/brotli/c' ${lib.getDev brotli}
  '';

  buildInputs = [ brotli ];

  passthru = {
    dynamic = true;
  };

  meta = {
    description = "Brotli compression";
    homepage = "https://github.com/google/ngx_brotli";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
