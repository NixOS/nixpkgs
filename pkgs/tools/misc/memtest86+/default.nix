{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "memtest86+-5.01";

  src = fetchurl {
    url = "http://www.memtest.org/download/5.01/${name}.tar.gz";
    sha256 = "0fch1l55753y6jkk0hj8f6vw4h1kinkn9ysp22dq5g9zjnvjf88l";
  };

  patches = [
    (fetchurl {
      url = "https://sources.debian.net/data/main/m/memtest86+/5.01-3/debian/patches/doc-serialconsole";
      sha256 = "1qh2byj9bmpchym8iq20n4hqmy10nrl6bi0d9pgdqikkmw9m38jq";
    })
    (fetchurl {
      url = "https://sources.debian.net/data/main/m/memtest86+/5.01-3/debian/patches/multiboot";
      sha256 = "0nq61307ah5b41ff5nqs99wjzjzlajvfv6k9c9d0gqvhx8r4dvmy";
    })
    (fetchurl {
      url = "https://sources.debian.net/data/main/m/memtest86+/5.01-3/debian/patches/memtest86+-5.01-O0.patch";
      sha256 = "1xmj3anq1fr0cxwv8lqfp5cr5f58v7glwc6z0v8hx8aib8yj1wl2";
    })
    (fetchurl {
      url = "https://sources.debian.net/data/main/m/memtest86+/5.01-3/debian/patches/memtest86+-5.01-array-size.patch";
      sha256 = "0yxlzpfs6313s91y984p7rlf5rgybcjhg7i9zqy4wqhm3j90f1kb";
    })
    (fetchurl {
      url = "https://sources.debian.net/data/main/m/memtest86+/5.01-3/debian/patches/gcc-5";
      sha256 = "13xfy6sn8qbj1hx4vms2cz24dsa3bl8n2iblz185hkn11y7141sc";
    })
  ];

  preBuild = ''
    # Really dirty hack to get Memtest to build without needing a Glibc
    # with 32-bit libraries and headers.
    if test "$system" = x86_64-linux; then
        mkdir gnu
        touch gnu/stubs-32.h
    fi
  '';

  NIX_CFLAGS_COMPILE = "-I. -std=gnu90";

  hardeningDisable = [ "fortify" "stackprotector" "pic" ];

  buildFlags = "memtest.bin";

  installPhase = ''
    mkdir -p $out
    chmod -x memtest.bin
    cp memtest.bin $out/
  '';

  meta = {
    homepage = http://www.memtest.org/;
    description = "A tool to detect memory errors";
    license = stdenv.lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
