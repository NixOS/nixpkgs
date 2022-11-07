{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, netlify-cli
}:

buildGoModule rec {
  pname = "esbuild";
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "esbuild";
    rev = "v${version}";
    sha256 = "0asjmqfzdrpfx2hd5hkac1swp52qknyqavsm59j8xr4c1ixhc6n9";
  };

  vendorSha256 = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";

  patches = [
    # Both upstream patches update the same dependency "x/sys". It's required for darwin compatibility.
    (fetchpatch {
      url = "https://github.com/evanw/esbuild/commit/2567e099fcc6959e630f100b2c737ca80e88ba82.patch";
      hash = "sha256-KdX/Ru9TBX0mSDaS1ijxgzDI+2AoCvt6Wilhpca3VC0=";
    })
    (fetchpatch {
      url = "https://github.com/evanw/esbuild/commit/fd13718c6195afb9e63682476a774fa6d4483be0.patch";
      hash = "sha256-va/bXRBQf9qgE9LZXcKKAa0ZpMt/QG7BFClJ8bPWG1Y=";
    })
  ];

  passthru = {
    tests = {
      inherit netlify-cli;
    };
  };

  meta = with lib; {
    description = "A fork of esbuild maintained by netlify";
    homepage = "https://github.com/netlify/esbuild";
    license = licenses.mit;
    maintainers = with maintainers; [ roberth ];
  };
}
