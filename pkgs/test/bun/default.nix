{ pkgs, stdenv }:
pkgs.buildBunModules {
  pname = "bun-hono-example";
  version = "1.0.87";
  vendorSha256 = if stdenv.isLinux then
    "sha256-hXe7j4HED6+DqMzBepsnz5HPAQQU+RKaE5gxTkYvAOE="
  else
    "sha256-ne/9TOoH69/DAtbR0vzEMWy2yTc3F2mRJsOU7ANEGLs=";
  src = ./.;
}
