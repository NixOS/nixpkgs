{ callPackage
, runCommand
, lib
, fetchurl
, perl
, postgresql
, nixosTests
, ...
}@args:

callPackage ../nginx/generic.nix args rec {
  pname = "openresty";
  nginxVersion = "1.25.3";
  version = "${nginxVersion}.2";

  src = fetchurl {
    url = "https://openresty.org/download/openresty-${version}.tar.gz";
    sha256 = "sha256-LVZAIrBuM7Rfflz68eXcVx041hgDr5+idU3/81PCjZw=";
  };

  # generic.nix applies fixPatch on top of every patch defined there.
  # This allows updating the patch destination, as openresty has
  # nginx source code in a different folder.
  fixPatch = patch:
    let name = patch.name or (builtins.baseNameOf patch); in
    runCommand "openresty-${name}" { src = patch; } ''
      substitute $src $out \
        --replace "a/" "a/bundle/nginx-${nginxVersion}/" \
        --replace "b/" "b/bundle/nginx-${nginxVersion}/"
    '';

  nativeBuildInputs = [ perl ];

  buildInputs = [ postgresql ];

  postPatch = ''
    patchShebangs configure bundle/
  '';

  configureFlags = [ "--with-http_postgres_module" ];

  postInstall = ''
    ln -s $out/luajit/bin/luajit-2.1.ROLLING $out/bin/luajit-openresty
    ln -sf $out/nginx/bin/nginx $out/bin/openresty
    ln -s $out/nginx/bin/nginx $out/bin/nginx
    ln -s $out/nginx/conf $out/conf
    ln -s $out/nginx/html $out/html
  '';

  passthru.tests = {
    inherit (nixosTests) openresty-lua;
  };

  meta = {
    description = "Fast web application server built on Nginx";
    homepage = "https://openresty.org";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice lblasc ];
  };
}
