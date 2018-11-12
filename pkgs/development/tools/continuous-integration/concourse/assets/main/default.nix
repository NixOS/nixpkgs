{
  cacert,
  gmp,
  mkYarnPackage,
  nodePackages,
  nss,
  patchelf,
  src,
  stdenv,
  zlib,
}:
mkYarnPackage {
  name = "concourse-main-assets";
  nativeBuildInputs = [ nodePackages.yarn patchelf cacert ];
  buildInputs = [ cacert ];
  inherit src;
  yarnNix = ./yarn.nix;
  pkgConfig = {
    elm = {
      postInstall = ''
        find . -type f -executable -exec patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" {} \;
        find . -type f -executable -exec patchelf --set-rpath "${gmp}/lib:${zlib}/lib:${nss}/lib" {} \;
      '';
    };
  };
  yarnFlags = [
    "--offline"
    "--frozen-lockfile"
  ];
  preBuild = ''
    mkdir -p elm_home
    export HOME=`realpath elm_home`
    yarn build
  '';
  installPhase = ''
    mkdir -p $out
    cp -R ./web/public $out/
  '';
}
