{ lib, stdenv
, autoPatchelfHook
, fetchurl
, zlib
}:

stdenv.mkDerivation rec {
  name = "1config";
  version = "0.21.0";

  buildInputs = [ stdenv.cc.cc.lib zlib ];
  nativeBuildInputs = [ autoPatchelfHook ];

  src = fetchurl {
    url = "https://github.com/BrunoBonacci/1config/releases/download/${version}/1cfg-Linux";
    sha256 = "0rynj8q903i3gypgmyvv43vk0hfz3q7bk2l65pmmk6fhyg9r2r9z";
    executable = true;
  };

  uisrc = fetchurl {
    url = "https://github.com/BrunoBonacci/1config/releases/download/${version}/1cfg-ui-beta";
    sha256 = "059jf9pm13bsk2cpccdr7pdcg46nbhx83d6wscvbid7p34sl4w6q";
    executable = true;
  };

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/1cfg
    cp $uisrc $out/bin/1cfg-ui-beta
  '';

  meta = with lib; {
    description = "A tool and a library to manage application secrets and configuration safely and effectively";
    homepage = "https://github.com/BrunoBonacci/1config";
    license = licenses.asl20;
    maintainers = with maintainers; [ davewm ];
    platforms = platforms.linux;
  };
}
