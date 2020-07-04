{ callPackage
, runCommand
, lib
, fetchurl
, postgresql
, ...
}@args:

callPackage ../nginx/generic.nix args rec {
  pname = "openresty";
  nginxVersion = "1.15.8";
  version = "${nginxVersion}.3";

  src = fetchurl {
    url = "https://openresty.org/download/openresty-${version}.tar.gz";
    sha256 = "1a1la7vszv1parsnhphydblz64ffhycazncn3ividnvqg2mg735n";
  };

  fixPatch = patch: let name = patch.name or (builtins.baseNameOf patch); in
    runCommand "openresty-${name}" { src = patch; } ''
      substitute $src $out \
        --replace "a/" "a/bundle/nginx-${nginxVersion}/" \
        --replace "b/" "b/bundle/nginx-${nginxVersion}/"
    '';

  buildInputs = [ postgresql ];

  configureFlags = [ "--with-http_postgres_module" ];

  preConfigure = ''
    patchShebangs .
  '';

  postInstall = ''
    ln -s $out/luajit/bin/luajit-2.1.0-beta3 $out/bin/luajit-openresty
    ln -s $out/nginx/sbin/nginx $out/bin/nginx
    ln -s $out/nginx/conf $out/conf
    ln -s $out/nginx/html $out/html
  '';

  meta = {
    description = "A fast web application server built on Nginx";
    homepage    = "http://openresty.org";
    license     = lib.licenses.bsd2;
    platforms   = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice lblasc emily ];
  };
}
