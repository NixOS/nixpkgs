{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  CoreServices,
}:
stdenv.mkDerivation rec {
  pname = "xmake";
  version = "2.9.5";
  src = fetchurl {
    url = "https://github.com/xmake-io/xmake/releases/download/v${version}/xmake-v${version}.tar.gz";
    hash = "sha256-A/61eH4i+rjdQEGew9hKvTWrzZ+KGyTEiMfrVx1nJMg=";
  };

  patches = [
    (fetchpatch {
      name = "xmake-fix-configure-compatibility.patch";
      url = "https://github.com/xmake-io/xmake/commit/2a1220727a367e753b92131577ab0c2fd974bff8.patch";
      hash = "sha256-xknlyydHvdwqTl975VQogKozT8nAp5+gPZQuRl1yXKE=";
    })
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin CoreServices;

  meta = with lib; {
    description = "Cross-platform build utility based on Lua";
    homepage = "https://xmake.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rewine
      rennsax
    ];
  };
}
