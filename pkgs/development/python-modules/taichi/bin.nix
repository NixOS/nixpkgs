{
  config,
  lib,
  autoPatchelfHook,
  autoAddDriverRunpath,
  buildPythonPackage,
  fetchPypi,
  stdenv,
  python,
  # python dependencies:
  dill,
  numpy,
  colorama,
  matplotlib,
  rich,
  # lib dependencies
  # vulkan-headers,
  vulkan-loader,
  libX11,
  libGL,
  libGLU,
  libz,
  # Options:
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:

let
  pname = "taichi";
  version = "1.7.2";
  format = "wheel";
  inherit (python) pythonVersion;

  packages =
    let
      getSrcFromPypi =
        {
          platform,
          dist,
          hash,
        }:
        fetchPypi {
          inherit
            pname
            version
            format
            platform
            dist
            ;
          # See the `disabled` attr comment below.
          sha256 = hash;
          python = dist;
          abi = dist;
        };
    in
    {
      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp312";
        hash = "6faa8d505b207807dc4e42e137dd6af76b0bfdedbd2aefa5ad59a231f355f104";
      };
      "3.12-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_x86_64";
        dist = "cp312";
        hash = "dca5b3ac63cc0369034d75c7fd1fee93288bd964fa2464778f1cc40540ab928a";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "5e02427f2f5109ce52e3a2c2a3a41e745a4a3e415a125386b12f2e7f9e45c9ff";
      };
      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp312";
        hash = "4d97a5d87839aabbe93083227cbd9049c1df03469f758209bdc516156d2f60d5";
      };
      "3.11-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_x86_64";
        dist = "cp312";
        hash = "53b037529268a4401f72aac9821b2f9b167b352697f392b19c93c946f14ad9a5";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "706148dfdf50cec5c9c70ae00b8d1689ca3b10b50447213f8b46de5465845f67";
      };
    };

  libPath = lib.makeLibraryPath (
    [
      libGL
      vulkan-loader
    ]
    ++ lib.optionals cudaSupport [ cudaPackages.cudatoolkit ]
  );
in
buildPythonPackage {
  inherit pname version format;
  src =
    packages."${pythonVersion}-${stdenv.hostPlatform.system}"
      or (throw "taichi-bin is not supported on ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
  ] ++ lib.optionals cudaSupport [ autoAddDriverRunpath ];

  preInstallCheck = ''
    shopt -s globstar

    for file in $out/**/*.so; do
      patchelf --add-rpath "${libPath}" "$file"
    done
  '';

  propagatedBuildInputs = [
    numpy
    colorama
    dill
    matplotlib
    rich

    # vulkan-headers
    vulkan-loader
    libGL
    libGLU
    libX11
    libz
  ];

  meta = with lib; {
    description = "Productive, portable, and performant GPU programming in Python.";
    homepage = "https://github.com/taichi-dev/taichi";
    license = licenses.asl20;
    maintainers = with maintainers; [ arunoruto ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
