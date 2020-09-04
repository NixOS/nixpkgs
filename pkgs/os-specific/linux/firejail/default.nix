{stdenv, fetchurl, fetchpatch, which}:
let
  s = # Generated upstream information
  rec {
    baseName="firejail";
    version="0.9.62";
    name="${baseName}-${version}";
    url="mirror://sourceforge/firejail/firejail/firejail-${version}.tar.xz";
    sha256="1q2silgy882fl61p5qa9f9jqkxcqnwa71jig3c729iahx4f0hs05";
  };
  buildInputs = [
    which
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
    name = "${s.name}.tar.bz2";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-17367.patch";
      url = "https://github.com/netblue30/firejail/commit/2c734d6350ad321fccbefc5ef0382199ac331b37.patch";
      sha256 = "1gxz4jxp80gxnn46195qxcpmikwqab9d0ylj9zkm62lycp84ij6n";
    })
    (fetchpatch {
      name = "CVE-2020-17368.patch";
      url = "https://github.com/netblue30/firejail/commit/34193604fed04cad2b7b6b0f1a3a0428afd9ed5b.patch";
      sha256 = "0n4ch3qykxx870201l8lz81f7h84vk93pzz77f5cjbd30cxnbddl";
    })
  ];

  prePatch = ''
    # Allow whitelisting ~/.nix-profile
    substituteInPlace etc/firejail.config --replace \
      '# follow-symlink-as-user yes' \
      'follow-symlink-as-user no'
  '';

  preConfigure = ''
    sed -e 's@/bin/bash@${stdenv.shell}@g' -i $( grep -lr /bin/bash .)
    sed -e "s@/bin/cp@$(which cp)@g" -i $( grep -lr /bin/cp .)
  '';

  preBuild = ''
    sed -e "s@/etc/@$out/etc/@g" -e "/chmod u+s/d" -i Makefile
  '';

  # We need to set the directory for the .local override files to
  # /etc/firejail so we can actually override them
  postInstall = ''
    sed -E -e 's@^include (.*.local)$@include /etc/firejail/\1@g' -i $out/etc/firejail/*.profile
  '';

  # At high parallelism, the build sometimes fails with:
  # bash: src/fsec-optimize/fsec-optimize: No such file or directory
  enableParallelBuilding = false;

  meta = {
    inherit (s) version;
    description = ''Namespace-based sandboxing tool for Linux'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = https://firejail.wordpress.com/;
    downloadPage = "https://sourceforge.net/projects/firejail/files/firejail/";
  };
}
