{ stdenv, fetchFromGitHub, wine, perl, autoconf, utillinux
, pulseaudio, libtxc_dxtn }:

let version = "1.7.40";
    patch = fetchFromGitHub {
      owner = "wine-compholio";
      repo = "wine-staging";
      rev = "v${version}";
      sha256 = "0l14yy6wbvbs2xrnn9z3a35lbnpl8ibkmc0vh983fimf9nxckpan";
    };

in assert (builtins.parseDrvName wine.name).version == version;

stdenv.lib.overrideDerivation wine (self: {
  nativeBuildInputs = [ pulseaudio libtxc_dxtn ] ++ self.nativeBuildInputs;
  buildInputs = [ perl utillinux autoconf ] ++ self.buildInputs;

  name = "${self.name}-staging";

  postPatch = self.postPatch or "" + ''
    patchShebangs tools
    cp -r ${patch}/patches .
    chmod +w patches
    cd patches
    patchShebangs gitapply.sh
    ./patchinstall.sh DESTDIR=.. --all
    cd ..
  '';
})
