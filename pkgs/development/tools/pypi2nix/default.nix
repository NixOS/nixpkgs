{ stdenv, fetchFromGitHub, fetchurl, pythonPackages, zip, makeWrapper, nix, nix-prefetch-git
, nix-prefetch-hg
}:

let

  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "garbas";
    repo = "pypi2nix";
    rev = "v${version}";
    sha256 = "039a2ys7ijzi2sa2haa6a8lbhncvd1wfsi6gcy9vm02gi31ghzyb";
  };

  click = fetchurl {
    url = "https://pypi.python.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz";
    sha256 = "02qkfpykbq35id8glfgwc38yc430427yd05z1wc5cnld8zgicmgi";
  };

  requests = fetchurl {
    url = "https://pypi.python.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz";
    sha256 = "1s0wg4any4dsv5l3hqjxqk2zgb7pdbqhy9rhc8kh3aigfq4ws8jp";
  };

in stdenv.mkDerivation rec {
  pname = "pypi2nix";
  inherit version;
  srcs = [
    src
    click
    requests
  ];
  buildInputs = [
    pythonPackages.python pythonPackages.flake8 pythonPackages.setuptools
    zip makeWrapper nix.out nix-prefetch-git nix-prefetch-hg
  ];

  sourceRoot = ".";

  postUnpack = ''
    mkdir -p $out/pkgs

    mv click-*/click                    $out/pkgs/click
    mv requests-*/requests              $out/pkgs/

    if [ -z "$IN_NIX_SHELL" ]; then
      if [ -e git-export ]; then
        mv git-export/src/pypi2nix      $out/pkgs/pypi2nix
      else
        mv source/src/pypi2nix          $out/pkgs/pypi2nix
      fi
    fi
  '';

  patchPhase = ''
    sed -i -e "s|default='nix-shell',|default='${nix.out}/bin/nix-shell',|" $out/pkgs/pypi2nix/cli.py
    sed -i -e "s|nix-prefetch-git|${nix-prefetch-git}/bin/nix-prefetch-git|" $out/pkgs/pypi2nix/stage2.py
    sed -i -e "s|nix-prefetch-hg|${nix-prefetch-hg}/bin/nix-prefetch-hg|" $out/pkgs/pypi2nix/stage2.py
  '';

  commonPhase = ''
    mkdir -p $out/bin

    echo "#!${pythonPackages.python.interpreter}" >  $out/bin/pypi2nix
    echo "import pypi2nix.cli" >> $out/bin/pypi2nix
    echo "pypi2nix.cli.main()" >> $out/bin/pypi2nix

    chmod +x $out/bin/pypi2nix

    export PYTHONPATH=$out/pkgs:$PYTHONPATH
  '';

  # flake8 doesn't run on python3
  doCheck = false;
  checkPhase = ''
    flake8 ${src}/src
  '';

  installPhase = commonPhase + ''
    wrapProgram $out/bin/pypi2nix \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --prefix PATH : "${nix-prefetch-git}/bin:${nix-prefetch-hg}/bin"
  '';

  shellHook = ''
    export home=`pwd`
    export out=/tmp/`pwd | md5sum | cut -f 1 -d " "`-$name

    rm -rf $out
    mkdir -p $out

    cd $out
    runHook unpackPhase
    runHook commonPhase
    cd $home

    export PATH=$out/bin:$PATH
    export PYTHONPATH=`pwd`/src:$PYTHONPATH
  '';

  meta = {
    homepage = https://github.com/garbas/pypi2nix;
    description = "A tool that generates nix expressions for your python packages, so you don't have to.";
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
