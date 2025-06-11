{
  lib,
  linkFarm,
  fetchurl,
  writers,
  torch,
  torchvision,
  runCommand,
}:
let
  fashionMnistDataset = linkFarm "fashion-mnist-dataset" (
    lib.mapAttrsToList
      (name: hash: {
        inherit name;
        path = fetchurl {
          url = "http://fashion-mnist.s3-website.eu-central-1.amazonaws.com/${name}";
          inherit hash;
        };
      })
      {
        "train-images-idx3-ubyte.gz" = "sha256-Ou3jjWGGOQiteGE/ajLtJxYm3RKAC6JjZWlRI2kmioQ=";
        "train-labels-idx1-ubyte.gz" = "sha256-oE8XE0rANWCkfjdk4RuS/JfeTRv6+LoaOqKa9UzJCEU=";
        "t10k-images-idx3-ubyte.gz" = "sha256-NG5VuUjZc6l+WNI1Hd4WpIS9QV1FlSl2M7sI8D22oHM=";
        "t10k-labels-idx1-ubyte.gz" = "sha256-Z9oXx26v/KVEbDNhqqtcPNbRwmCHZNNd+xhQsIa/jdU=";
      }
  );

  mnist-script = writers.writePython3 "test_mnist" {
    libraries = [
      torch
      torchvision
    ];
    flakeIgnore = [ "E501" ];
  } (builtins.readFile ./script.py);
in
runCommand "mnist" { } ''
  mkdir -p data/FashionMNIST/raw

  for archive in `ls ${fashionMnistDataset}`; do
    gzip -d < "${fashionMnistDataset}/$archive" > data/FashionMNIST/raw/"''${archive%.*}"
  done

  ${mnist-script}

  touch $out
''
