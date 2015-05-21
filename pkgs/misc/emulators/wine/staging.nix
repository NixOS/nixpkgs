{ stdenv, fetchFromGitHub, wine, perl, autoconf, utillinux
, pulseaudio, libtxc_dxtn }:

let version = "1.7.42";
    patch = fetchFromGitHub {
      owner = "wine-compholio";
      repo = "wine-staging";
      rev = "v${version}";
      sha256 = "1qi1hf1w97n17vmj137p7da75g01ky84a3xvs50xrmxb7f62sm17";
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
