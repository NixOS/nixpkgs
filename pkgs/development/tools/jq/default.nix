{ lib, stdenv, nixosTests, fetchurl, oniguruma }:

stdenv.mkDerivation rec {
  pname = "jq";
  version = "1.6";

  src = fetchurl {
    url =
      "https://github.com/stedolan/jq/releases/download/jq-${version}/jq-${version}.tar.gz";
    sha256 = "0wmapfskhzfwranf6515nzmm84r7kwljgfs7dg6bjgxakbicis2x";
  };

  outputs = [ "bin" "doc" "man" "dev" "lib" "out" ];

  buildInputs = [ oniguruma ];

  configureFlags = [
    "--bindir=\${bin}/bin"
    "--sbindir=\${bin}/bin"
    "--datadir=\${doc}/share"
    "--mandir=\${man}/share/man"
  ]
  # jq is linked to libjq:
    ++ lib.optional (!stdenv.isDarwin) "LDFLAGS=-Wl,-rpath,\\\${libdir}";

  doInstallCheck = true;
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
