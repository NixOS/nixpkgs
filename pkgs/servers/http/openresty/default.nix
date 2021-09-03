{ callPackage
, runCommand
, lib
, fetchurl
, postgresql
, ...
}@args:

callPackage ../nginx/generic.nix args rec {
  pname = "openresty";
  nginxVersion = "1.19.3";
  version = "${nginxVersion}.2";

  src = fetchurl {
    url = "https://openresty.org/download/openresty-${version}.tar.gz";
    sha256 = "1fav3qykckqcyw9ksi8s61prpwab44zbcvj95rwfpfqgk5jffh6f";
  };

  # generic.nix applies fixPatch on top of every patch defined there.  This
  # allows updating the patch destination, as openresty has nginx source code
  # in a different folder.
  fixPatch = patch:
    let name = patch.name or (builtins.baseNameOf patch); in
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
    homepage = "https://openresty.org";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice lblasc emily ];
  };
}
