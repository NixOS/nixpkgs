{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, vulkan-headers
, libX11
, libGL
, libxkbcommon
, libXcursor
, libXfixes
, wayland
, x11Support ? true
, waylandSupport ? true
, nix-update-script
, stdenv
}:

buildGoModule rec {
  pname = "lensm";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "loov";
    repo = "lensm";
    rev = "v${version}";
    sha256 = "sha256-v4C2ZCJUUKRfnaFoL9wu9hzZk84NIPjRo3DAL7kM2Bw=";
  };

  vendorSha256 = "sha256-TMvIh+iBW22Xt+y6S92Cdvk3cMLEE6TXyBgxwEbEros=";

  tags = lib.optionals (!x11Support) [ "nox11" ] ++ lib.optionals (!waylandSupport) [ "nowayland" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    let
      x11Deps = [ libX11 libXcursor libXfixes ];
      waylandDeps = [ wayland ];
    in
    [ vulkan-headers libGL libxkbcommon ]
    ++ lib.optionals x11Support x11Deps
    ++ lib.optionals waylandSupport waylandDeps;

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    # gioui.org/internal/cocoainit fails with:
    #  fatal error: could not build module 'CoreFoundation'
    # even when it's included as dependency.
    broken = stdenv.isDarwin;

    description = "Go assembly and source viewer";
    homepage = "https://github.com/loov/lensm";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
