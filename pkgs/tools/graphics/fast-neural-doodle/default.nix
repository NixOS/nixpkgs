{stdenv, fetchFromGitHub, fetchurl, torch, torch-hdf5, loadcaffe, bash
  , python, numpy, scipy, h5py, scikitlearn, pillow
  }:
stdenv.mkDerivation rec {
  name = "fast-neural-doodle-${version}";
  version = "0.0pre2016-07-01";
  buildInputs = [
    torch torch-hdf5 python numpy h5py scikitlearn scipy pillow
  ];

  inherit torch loadcaffe bash python;
  torch_hdf5 = torch-hdf5;
  python_libPrefix = python.libPrefix;

  src = fetchFromGitHub {
    owner = "DmitryUlyanov";
    repo = "fast-neural-doodle";
    rev = "00c35a4440d1d58b029d7bdf9bc56743b1a1835f";
    sha256 = "0xhmhxhjm59pfjm2q27g2xfb35hg0vlqkk3sb3llx2qqq2c7jk8m";
  };
  models = [
    (fetchurl {
      url = "https://gist.githubusercontent.com/ksimonyan/3785162f95cd2d5fee77/raw/bb2b4fe0a9bb0669211cf3d0bc949dfdda173e9e/VGG_ILSVRC_19_layers_deploy.prototxt";
      sha256 = "09cpz7pyvc8sypg2q5j2i8yqwj1sjdbnmd6skl293p9pv13dmjg7";
    })
    (fetchurl {
      url = "https://bethgelab.org/media/uploads/deeptextures/vgg_normalised.caffemodel";
      sha256 = "11qckdvlck7wwl3pan0nawgxm8l2ccddi272i5l8rs9qzm7b23rf";
    })
    (fetchurl {
      url = "http://www.robots.ox.ac.uk/~vgg/software/very_deep/caffe/VGG_ILSVRC_19_layers.caffemodel";
      sha256 = "0m399x7pl4lnhy435ycsyz8xpzapqmx9n1sz698y2vhcqhkwdd1i";
    })
  ];
  installPhase = ''
    mkdir -p "$out"/{doc/fast-neural-doodle,lib/lua/fast_neural_doodle,lib/${python.libPrefix}/fast_neural_doodle,bin}
    cp -r data src fast_neural_doodle.lua "$out/lib/lua/fast_neural_doodle/"
    for file in $models; do
      ln -s "$file" "$out/lib/lua/fast_neural_doodle/data/pretrained/$(basename "$file" | sed -e 's/[^-]*-//')"
    done;
    cp get_mask_hdf5.py "$out/lib/${python.libPrefix}/fast_neural_doodle"
    cp *.md LICENSE "$out/doc/fast-neural-doodle"

    export pythonpath="$PYTHONPATH"

    substituteAll "${./get-mask-hdf5.sh}" "$out/bin/get-mask-hdf5"
    substituteAll "${./fast-neural-doodle.sh}" "$out/bin/fast-neural-doodle"

    chmod a+x "$out/bin"/*

    "$out/bin/get-mask-hdf5" --n_colors=4 --style_image data/Renoir/style.png --style_mask data/Renoir/style_mask.png --target_mask data/Renoir/target_mask.png --out_hdf5 masks.hdf5

    "$out/bin/fast-neural-doodle" -gpu -1 -masks_hdf5 masks.hdf5 -num_iterations 1
  '';
  meta = {
    inherit version;
    description = ''Faster neural doodle'';
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
