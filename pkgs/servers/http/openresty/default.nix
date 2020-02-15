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
  version = "${nginxVersion}.2";

  src = fetchurl {
    url = "https://openresty.org/download/openresty-${version}.tar.gz";
    sha256 = "05jxrb8hv758nm38jil8n63q1nhrz3d249bsrwc7maa7sn24wss3";
  };

  fixPatch = patch:
    runCommand "openresty-${patch.name}" { src = patch; } ''
      substitute $src $out \
        --replace "src/" "bundle/nginx-${nginxVersion}/src/"
    '';

  buildInputs = [ postgresql ];

  configureFlags = [ "--with-http_postgres_module" ];

  preConfigure = ''
    patchShebangs .
  '';

  postInstall = ''
    ln -s $out/luajit/bin/luajit-2.1.0-beta3 $out/bin/luajit-openresty
    ln -s $out/nginx/sbin/nginx $out/bin/nginx
  '';

  meta = {
    description = "A fast web application server built on Nginx";
    homepage    = http://openresty.org;
    license     = lib.licenses.bsd2;
    platforms   = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice lblasc emily ];
  };
}
