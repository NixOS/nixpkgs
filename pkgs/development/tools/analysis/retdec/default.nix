{ stdenv, fetchFromGitHub, fetchurl, fetchzip,
# Native build inputs
cmake,
autoconf, automake, libtool,
pkgconfig,
bison, flex,
groff,
perl,
python,
# Runtime tools
time,
upx,
# Build inputs
ncurses,
libffi,
libxml2,
zlib,
# PE (Windows) data, huge space savings if not needed
withPEPatterns ? false,
}:

let
  release = "3.0";

  rapidjson = fetchFromGitHub {
    owner = "Tencent";
    repo = "rapidjson";
    rev = "v1.1.0";
    sha256 = "1jixgb8w97l9gdh3inihz7avz7i770gy2j2irvvlyrq3wi41f5ab";
  };
  jsoncpp = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = "1.8.3";
    sha256 = "05gkmg6r94q8a0qdymarcjlnlvmy9s365m9jhz3ysvi71cr31lkz";
  };
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-1.8.0";
    sha256 = "0bjlljmbf8glnd9qjabx73w6pd7ibv43yiyngqvmvgxsabzr8399";
  };
  tinyxml2 = fetchFromGitHub {
    owner = "leethomason";
    repo = "tinyxml2";
    rev = "5.0.1";
    sha256 = "015g8520a0c55gwmv7pfdsgfz2rpdmh3d1nq5n9bd65n35492s3q";
  };
  yara = fetchurl {
     url = "https://github.com/avast-tl/yara/archive/v1.0-retdec.zip";
     sha256 = "1bjrkgp1sgld2y7gvwrlrz5fs16521ink6xyq72v7yxj3vfa9gps";
  };
  openssl = fetchurl {
    url = "https://www.openssl.org/source/openssl-1.1.0f.tar.gz";
    sha256 = "0r97n4n552ns571diz54qsgarihrxvbn7kvyv8wjyfs9ybrldxqj";
  };

  retdec-support = fetchzip {
    url = "https://github.com/avast-tl/retdec-support/releases/download/2017-12-12/retdec-support_2017-12-12.tar.xz";
    sha256 = if withPEPatterns then "0pchl7hb42dm0sdbmpr8d3c6xc0lm6cs4p6g6kdb2cr9c99gjzn3"
                               else "1hcyq6bf4wk739kb53ic2bs71gsbx6zd07pc07lzfnxf8k497mhv";
    # Removing PE signatures reduces this from 3.8GB -> 642MB (uncompressed)
    extraPostFetch = stdenv.lib.optionalString (!withPEPatterns) ''
      rm -rf $out/generic/yara_patterns/static-code/pe
    '';
  };
in stdenv.mkDerivation rec {
  name = "retdec-${version}";
  version = "${release}.0";

  src = fetchFromGitHub {
    owner = "avast-tl";
    repo = "retdec";
    name = "retdec-${release}";
    rev = "refs/tags/v${release}";
    sha256 = "0cpc5lxg8qphdzl3gg9dx992ar35r8ik8wyysr91l2qvfhx93wks";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake autoconf automake libtool pkgconfig bison flex groff perl python ];

  buildInputs = [ ncurses libffi libxml2 zlib ];

  prePatch = ''
    find . -wholename "*/deps/rapidjson/CMakeLists.txt" -print0 | \
      xargs -0 sed -i -e 's|GIT_REPOSITORY.*|URL ${rapidjson}|'
    find . -wholename "*/deps/jsoncpp/CMakeLists.txt" -print0 | \
      xargs -0 sed -i -e 's|GIT_REPOSITORY.*|URL ${jsoncpp}|'
    find . -wholename "*/deps/googletest/CMakeLists.txt" -print0 | \
      xargs -0 sed -i -e 's|GIT_REPOSITORY.*|URL ${googletest}|'
    find . -wholename "*/deps/tinyxml2/CMakeLists.txt" -print0 | \
      xargs -0 sed -i -e 's|GIT_REPOSITORY.*|URL ${tinyxml2}|'

    find . -wholename "*/yaracpp/deps/CMakeLists.txt" -print0 | \
      xargs -0 sed -i -e 's|URL .*|URL ${yara}|'

    find . -wholename "*/deps/openssl/CMakeLists.txt" -print0 | \
      xargs -0 sed -i -e 's|OPENSSL_URL .*)|OPENSSL_URL ${openssl})|'

    cat > cmake/install-share.sh <<EOF
      #!/bin/sh
      mkdir -p $out/share/retdec/
      ln -s ${retdec-support} $out/share/retdec/support
    EOF
    chmod +x cmake/*.sh
    patchShebangs cmake/*.sh

    substituteInPlace scripts/unpack.sh --replace '	upx -d' '	${upx}/bin/upx -d'
    substituteInPlace scripts/config.sh --replace /usr/bin/time ${time}/bin/time
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A retargetable machine-code decompiler based on LLVM";
    homepage = https://retdec.com;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    broken = withPEPatterns; # retdec-full is broken, 2018-04-11
  };
}
