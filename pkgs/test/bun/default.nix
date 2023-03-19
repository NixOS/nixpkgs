{ pkgs }:
pkgs.buildBunModules {
  pname = "bun-hono-example";
  version = "1.0.87";
  vendorSha256 = "sha256-ne/9TOoH69/DAtbR0vzEMWy2yTc3F2mRJsOU7ANEGLs=";
  src = ./.;
}
