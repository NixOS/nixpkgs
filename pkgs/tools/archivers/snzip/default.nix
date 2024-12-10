{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  snappy,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snzip";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "kubo";
    repo = "snzip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-trxCGVNw2MugE7kmth62Qrp7JZcHeP1gdTZk32c3hFg=";
  };

  # We don't use a release tarball so we don't have a `./configure` script to
  # run. That's why we generate it.
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    snappy
  ];

  meta = with lib; {
    description = "A compression/decompression tool based on snappy";
    homepage = "https://github.com/kubo/snzip";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
})
