{
  callPackage,
  runCommand,
  lib,
  fetchurl,
  perl,
  libpq,
  nixosTests,
  withPostgres ? true,
  ...
}@args:

callPackage ../nginx/generic.nix args rec {
  pname = "openresty";
  nginxVersion = "1.27.1";
  version = "${nginxVersion}.2";

  src = fetchurl {
    url = "https://openresty.org/download/openresty-${version}.tar.gz";
    sha256 = "sha256-dPB29+NksqmabF+btTHCdhDHiYWr6Va0QrGSoilfdUg=";
  };

  # generic.nix applies fixPatch on top of every patch defined there.
  # This allows updating the patch destination, as openresty has
  # nginx source code in a different folder.
  fixPatch =
    patch:
    let
      name = patch.name or (baseNameOf patch);
    in
    runCommand "openresty-${name}" { src = patch; } ''
      substitute $src $out \
        --replace "a/" "a/bundle/nginx-${nginxVersion}/" \
        --replace "b/" "b/bundle/nginx-${nginxVersion}/"
    '';

  nativeBuildInputs = [
    libpq.pg_config
    perl
  ];

  buildInputs = [ libpq ];

  postPatch = ''
    substituteInPlace bundle/nginx-${nginxVersion}/src/http/ngx_http_core_module.c \
      --replace-fail '@nixStoreDir@' "$NIX_STORE" \
      --replace-fail '@nixStoreDirLen@' "''${#NIX_STORE}"

    patchShebangs configure bundle/
  '';

  configureFlags = lib.optional withPostgres [ "--with-http_postgres_module" ];

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
    maintainers = with lib.maintainers; [
      thoughtpolice
      lblasc
    ];
  };
}
