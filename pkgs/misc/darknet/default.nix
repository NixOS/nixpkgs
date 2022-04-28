{ stdenv
, lib
, opencv2
, fetchFromGitHub
, cudaPackages
, pkg-config
, enableCuda ? false
, enableCuDNN ? false
, enableOpenCV ? false
, enableOpenMP ? true
, enableDebug ? false
}:
let
  bool2str = b: if b then "1" else "0"; # what is this function from nixpkgs?
in stdenv.mkDerivation {
  name = "darknet";
  version = "unstable-2022-05-05";

  src = fetchFromGitHub {
    owner = "pjreddie";
    repo = "darknet";
    rev = "b1ab3da442574364f82c09313a58f7fc93cea2bd";
    sha256 = "sha256-3/rJU2l4VQGySnviRo+PasydKEbY+By9574rAa5xTUM=";
  };

  patches = [ ./remove-default-flags.patch ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ ]
    ++ lib.optionals enableCuda [ cudaPackages.cudatoolkit ]
    ++ lib.optionals enableCuDNN [ cudaPackages.cudnn ]
    ++ lib.optionals enableOpenCV [ (opencv2.override {enableGtk2 = true; }).dev ]
  ;

  makeFlags = [
    "GPU=${bool2str enableCuda}"
    "CUDNN=${bool2str enableCuDNN}"
    "OPENCV=${bool2str enableOpenCV}"
    "OPENMP=${bool2str enableOpenMP}"
    "DEBUG=${bool2str enableDebug}" # is there any nixpkgs specific way to enable debugging that could propagate to this?
  ];

  installPhase = ''
    mkdir $out/{bin,lib} -p
    install -m 755 darknet $out/bin
    install -m 755 libdarknet.a $out/lib
    install -m 755 libdarknet.so $out/lib
    ln -s include $out/include
    for version in 3.7 3.8 3.9 3.10; do
      mkdir -p $out/lib/python$version/site-packages/darknet
      install -m 755 python/darknet.py $out/lib/python$version/site-packages/darknet/__init__.py
      sed "s;libdarknet.so;$out/lib/libdarknet.so;" -i $out/lib/python$version/site-packages/darknet/__init__.py
    done
    ln -s $src $out/src
  '';

  meta = with lib; {
    description = " Open source neural networks in C";
    homepage = "https://pjreddie.com/darknet/";
    license = licenses.unfree; # i am not sure
    platforms = platforms.linux;
    maintainers = with maintainers; [ lucasew ];
  };
}
