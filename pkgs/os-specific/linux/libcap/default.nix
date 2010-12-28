{stdenv, fetchurl, attr, perl}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-${version}";
  version = "2.19";
  
  src = fetchurl {
    url = "mirror://kernel/linux/libs/security/linux-privs/kernel-2.6/${name}.tar.gz";
    sha256 = "0fdsz9j741npvh222f8p1y6l516z9liibiwdpdr3a4zg53m0pw45";
  };
  
  buildNativeInputs = [perl];
  propagatedBuildInputs = [attr];

  preConfigure = "cd libcap";

  makeFlags = "lib=lib prefix=$(out)";

  passthru = {
    postinst = n : ''
      ensureDir $out/share/doc/${n}
      cp ../License $out/share/doc/${n}/License
    '';
  };

  postInstall = passthru.postinst name;
}
