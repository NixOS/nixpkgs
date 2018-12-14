{stdenv, lib, fetchurl}:

let
  version = "0.5.18";

  manpageHash = "1gq9dmddypamghzkj3wgfha40gnixzhrr7g7ssambq1w5x2bc1yq";

  binaries = lib.mapAttrs hashToBinary {
    "aarch64-linux-gnu"         = "0kk3h4wl08d9a1flfq4drc6hdkln2aj9gfj1fjsvv63rmlfflip9";
    "alpha-linux-gnu"           = "1jjdnhcwwd89q82ygcbi2p7isz95fc9gsiribq0dn1aim9vdfb4z";
    "arm-linux-gnueabi"         = "1ccdww1m5jnv9ggb0dyx7llichivza6ddp2y6v7bd9pdqgypxlix";
    "arm-linux-gnueabihf"       = "1qywdmwj4zrqcn0b0n2vr7svqjiw4idpdj97wqrkm7scgzf7iy41";
    "hppa-linux-gnu"            = "1l68wb6384hw08f7swyh8n68ssnn478x7j6sxc2gj1cs3kxxac29";
    "mips-linux-gnu"            = "06r214ckfgzr1vjf4bhn236755qx22hjwm521ly1pa4dscfwq9jq";
    "mips64-linux-gnuabi64"     = "04gnhih3j1za6bz77i9lxp9k4lxsmaacgiwvy4r9v6rqk5fyx5ga";
    "mips64el-linux-gnuabi64"   = "1smy3pmpssqkg0n42sgrvzwirgfdsqvsrcaa5g84pysgipxakqnn";
    "mipsel-linux-gnu"          = "0w51254qzm0f7c0zj30135a00djkl1krwbl6km0ndgy9apqhnpzp";
    "powerpc-linux-gnu"         = "1rn39s12wwyk67a2sk3292vsg2cf751gbhhs7rpjrqpxvix9r6d1";
    "powerpc64-linux-gnu"       = "1iqsh7sx75v839xl4mwxdg6wylx4lnapkkm3n93xlx5xjyb1sbg7";
    "powerpc64le-linux-gnu"     = "01q6s7cbdaxhg2h5jm1pf5da2zj6kk53mfdpvn8h1m96khqz1ckb";
    "riscv64-linux-gnu"         = "19l8lc53jxda0wfsyb9zmhmcssp4sasgz1drvh4s496hyk7m9bih";
    "s390x-linux-gnu"           = "1prvnid93krfp7phzq67xrkfss60nk4ikfra4cypw3rhzwp4xsgd";
    "sh4-linux-gnu"             = "1igvb1faj4k001z6h9kw688fhra7w7a8h176crw54j8fksnls2nw";
    "x86_64-apple-darwin"       = "1yhlw7jan8pbg6vz9x1ksvnp1hksnq5c466yap7bqywsz8q8686g";
    "x86_64-unknown-linux-icc"  = "1ywf7ivwgichknk04rbdpzisydidklyn676hds8qmvffynvv4qrc";
  };

  target = with stdenv.hostPlatform;
    let
      arch = if parsed.cpu.name == "armv7l" then "arm" else parsed.cpu.name;
      machine =
        if isDarwin then "apple-darwin"
        else if isLinux && isx86_64 then "unknown-linux-icc"
        else "${parsed.kernel.name}-${parsed.abi.name}";
    in
     "${arch}-${machine}";

  hashToBinary = name: value: fetchurl {
    name = "poly-${name}-${version}";
    url = "https://github.com/vmchale/polyglot/releases/download/${version}/poly-${name}";
    sha256 = value;
  };

in
  stdenv.mkDerivation rec {
    name = "polyglot-${version}";
    inherit version;

    binary = binaries.${target} or (throw "Package ${name} is not supported on ${stdenv.hostPlatform.system}");

    manpage = fetchurl {
      name = "${name}-manpage";
      url = "https://github.com/vmchale/polyglot/releases/download/${version}/poly.1";
      sha256 = manpageHash;
    };

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup

      mkdir -p $out/bin
      cp $binary $out/bin/poly
      chmod +x $out/bin/poly
      mkdir -p $out/share/man/man1
      cp $manpage $out/share/man/man1/poly.1
    '';

    meta = with stdenv.lib; {
      description = "A tool to count lines of source code quickly and accurately";
      homepage = https://github.com/vmchale/polyglot;
      license = licenses.bsd3;
    };
}
