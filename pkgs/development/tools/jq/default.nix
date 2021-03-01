{ lib, stdenv, nixosTests, fetchurl, oniguruma, minimal ? false }:

stdenv.mkDerivation rec {
  pname = "jq";
  version = "1.6";

  src = fetchurl {
    url =
      "https://github.com/stedolan/jq/releases/download/jq-${version}/jq-${version}.tar.gz";
    sha256 = "0wmapfskhzfwranf6515nzmm84r7kwljgfs7dg6bjgxakbicis2x";
  };

  outputs = if minimal then [ "out" ] else [ "bin" "doc" "man" "dev" "lib" "out" ];

  buildInputs = stdenv.lib.optional (!minimal) oniguruma;

  configureFlags =
    if minimal then [ "--with-oniguruma=no" "--enable-all-static" ]
    else [
      "--bindir=\${bin}/bin"
      "--sbindir=\${bin}/bin"
      "--datadir=\${doc}/share"
      "--mandir=\${man}/share/man"
    ]
    # jq is linked to libjq:
    ++ lib.optional (!stdenv.isDarwin) "LDFLAGS=-Wl,-rpath,\\\${libdir}";

  preFixup = stdenv.lib.optionalString minimal ''
    rm -r .libs $out/{include,share}
    patchelf --shrink-rpath $out/bin/jq
  '';

  doInstallCheck = !minimal;
  installCheckTarget = "check";

  postInstallCheck = ''
    $bin/bin/jq --help >/dev/null
  '';

  passthru.tests = { inherit (nixosTests) jq; };

  meta = with lib; {
    description = "A lightweight and flexible command-line JSON processor";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin globin ];
    platforms = with platforms; linux ++ darwin;
    downloadPage = "http://stedolan.github.io/jq/download/";
    updateWalker = true;
    inherit version;
  };
}
