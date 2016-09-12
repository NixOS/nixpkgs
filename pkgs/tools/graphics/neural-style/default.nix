{stdenv, fetchFromGitHub, torch, loadcaffe, fetchurl, bash}:
stdenv.mkDerivation rec {
  name = "neural-style-${version}";
  version = "0.0pre2016.08.15";
  buildInputs = [torch loadcaffe];
  src = fetchFromGitHub {
    owner = "jcjohnson";
    repo = "neural-style";
    rev = "ec5ba3a690d3090428d3b92b0c5d686a311bf432";
    sha256 = "14qzbs9f95izvd0vbbirhymdw9pq2nw0jvhrh7vnyzr99xllwp02";
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
    mkdir -p "$out"/{bin,lib/lua/neural-style/models,share/doc/neural-style,share/neural-style}
    for file in $models; do
      ln -s "$file" "$out/lib/lua/neural-style/models/$(basename "$file" | sed -e 's/[^-]*-//')"
    done;
    cp README* INSTALL* LICEN?E* "$out"/share/doc/neural-style/
    cp neural_style.lua "$out"/lib/lua/neural-style

    substituteAll "${./neural-style.sh}" "$out/bin/neural-style"
    chmod a+x "$out/bin/neural-style"
    cp "$out/bin/neural-style" .
    cp "$out/lib/lua/neural-style/models/"* models/

    echo "Testing..."

    "$out/bin/neural-style" -style_image examples/inputs/golden_gate.jpg \
      -content_image examples/inputs/golden_gate.jpg -output_image $PWD/test.png \
      -gpu -1 -save_iter 1 -print_iter 1 -num_iterations 1 || true

    cp -f "$out/lib/lua/neural-style/models/"* models/

    test -e test.png || exit 1
  '';
  inherit torch bash loadcaffe;
  meta = {
    inherit version;
    description = ''A torch implementation of the paper A Neural Algorithm of Artistic Style'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    # Eats a lot of RAM
    platforms = ["x86_64-linux"];
  };
}
