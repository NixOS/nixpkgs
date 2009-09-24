{ stdenv, fetchurl, lib, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
, nameSuffix ? ""
, debugcCoercionFailuresPatch ? false
  /* enabling this experimental patch will output a xml representation of the
     thing which didn't match the expected type - for debugging only

     The message of
      let a = {}; in builtins.substring a a a; # always cause failure
     looks like
 
     value is an attribute set while an integer was expected
     <?xml version='1.0' encoding='utf-8'?>
     <expr>
       <attrs>
       </attrs>
     </expr>
   */
, patches ? []
}:


let
   

  allPatches =
      patches ++ lib.optional debugcCoercionFailuresPatch
                      (fetchurl { url = http://mawercer.de/~marc/debug-coercion-failures.patch; sha256 = "13q6vbxp3p36hqzlfp0hw84n6f1hzljnxqy73vr2bmglp8np24wy"; });
  
  vName = "nix-0.13pre17232";
  name = "${vName}${nameSuffix}${if allPatches == [] then "" else "-patched"}";
in

stdenv.mkDerivation {
  
  inherit name;
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/75293/download/4/${name}.tar.bz2";
    sha256 = "aaea96d6dd87f8cceb2973e561d1cd0ca1beeaa0384eb91f4db09ac75d42148f";
  };

  buildInputs = [perl curl openssl];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bzip2=${bzip2}
    ${if supportOldDBs then "--with-bdb=${db4}" else "--disable-old-db-compat"}
    --disable-init-state
  '';

  doCheck = true;

  passthru = { inherit aterm; };

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPL";
  };

  patches = allPatches;
}
