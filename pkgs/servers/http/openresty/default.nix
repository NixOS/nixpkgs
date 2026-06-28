{
  callPackage,
  runCommand,
  lib,
  fetchurl,
  perl,
  libpq,
  nixosTests,
  withPostgres ? true,
  curl,
  jq,
  nix-update,
  writeShellApplication,
  ...
}@args:

callPackage ../nginx/generic.nix args rec {
  pname = "openresty";
  version = "1.31.1.1";
  nginxVersion = lib.concatStringsSep "." (lib.init (lib.splitString "." version));

  src = fetchurl {
    url = "https://openresty.org/download/openresty-${version}.tar.gz";
    hash = "sha256-ZbeLqt0/CYQFXeib8T9KGTLlv+nDGTIDehNOorGgzkI=";
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

  configureFlags = lib.optionals withPostgres [ "--with-http_postgres_module" ];

  postInstall = ''
    ln -s $out/luajit/bin/luajit-2.1.ROLLING $out/bin/luajit-openresty
    ln -sf $out/nginx/bin/nginx $out/bin/openresty
    ln -s $out/nginx/bin/nginx $out/bin/nginx
    ln -s $out/nginx/conf $out/conf
    ln -s $out/nginx/html $out/html
  '';

  passthru = {
    tests = {
      inherit (nixosTests) openresty-lua;
      inherit (nixosTests.nginx-variants) openresty;
    };
    updateScript = lib.getExe (writeShellApplication {
      name = "openresty-update";
      runtimeInputs = [
        curl
        jq
        nix-update
      ];
      text = ''
        version="$(
          curl -fsSL https://api.github.com/repos/openresty/openresty/tags?per_page=1 |
            jq -r '.[0].name' |
            sed 's/^v//'
        )"
        echo "Local: ${version}"
        echo "Latest: $version"

        nix-update \
          --override-filename="pkgs/servers/http/openresty/default.nix" \
          --version="''${version}" \
          openresty
      '';
    });
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
