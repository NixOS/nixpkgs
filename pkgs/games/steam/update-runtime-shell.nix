with import <nixpkgs> {};

(python2.buildEnv.override {
  extraLibs = with python2Packages;
    [ debian
    ];
  postBuild = ''
    mkdir -p $out/bin
    for i in ${nixUnstable}/bin/*; do
      ln -s $i $out/bin/$(basename $i)
    done
  '';
}).env
