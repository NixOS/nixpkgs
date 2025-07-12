{ fetchpatch }:

[
  # Makes `npm pack` obey `--foreground-scripts`
  (fetchpatch {
    name = "libnpmpack-obey-foreground-scripts.patch";
    url = "https://github.com/npm/cli/commit/e4e8ae20aef9e27e57282e87e8757d5b364abb39.patch";
    hash = "sha256-NQ8CZBfRqAOMe0Ysg3cq1FiferWKTzXC1QXgzX+f8OU=";
    stripLen = 2;
    extraPrefix = "deps/npm/node_modules/";
    includes = [ "deps/npm/node_modules/libnpmpack/lib/index.js" ];
  })

  # Makes `npm pack` obey `--ignore-scripts`
  (fetchpatch {
    name = "libnpmpack-obey-ignore-scripts.patch";
    url = "https://github.com/npm/cli/commit/a990c3c9a0e67f0a8b6454213675e159fe49432d.patch";
    hash = "sha256-eA5YST9RxMMjk5FCwEbl1HQUpXZuwWZkx5WC4yJium8=";
    stripLen = 2;
    extraPrefix = "deps/npm/node_modules/";
    includes = [ "deps/npm/node_modules/libnpmpack/lib/index.js" ];
  })
]
