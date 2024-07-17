{
  lib,
  stdenv,
  fetchurl,
  ...
}:
let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation rec {
  pname = "libtensorflow-photoprism";
  version = "1.15.2";

  srcs = [
    # Photoprism-packaged libtensorflow tarball (with pre-built libs for both arm64 and amd64)
    # We need this specific version because of https://github.com/photoprism/photoprism/issues/222
    (fetchurl {
      sha256 =
        {
          x86_64-linux = "sha256-bZAC3PJxqcjuGM4RcNtzYtkg3FD3SrO5beDsPoKenzc=";
          aarch64-linux = "sha256-qnj4vhSWgrk8SIjzIH1/4waMxMsxMUvqdYZPaSaUJRk=";
        }
        .${system};

      url =
        let
          systemName =
            {
              x86_64-linux = "amd64";
              aarch64-linux = "arm64";
            }
            .${system};
        in
        "https://dl.photoprism.app/tensorflow/${systemName}/libtensorflow-${systemName}-${version}.tar.gz";
    })
    # Upstream tensorflow tarball (with .h's photoprism's tarball is missing)
    (fetchurl {
      url = "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-1.15.0.tar.gz";
      sha256 = "sha256-3sv9WnCeztNSP1XM+iOTN6h+GrPgAO/aNhfbeeEDTe0=";
    })
  ];

  sourceRoot = ".";

  unpackPhase = ''
    sources=($srcs)

    mkdir downstream upstream
    tar xf ''${sources[0]} --directory downstream
    tar xf ''${sources[1]} --directory upstream

    mv downstream/lib .
    mv upstream/{include,LICENSE,THIRD_PARTY_TF_C_LICENSES} .
    rm -r downstream upstream

    cd lib
    ln -sT libtensorflow.so{,.1}
    ln -sT libtensorflow_framework.so{,.1}
    cd ..
  '';

  # Patch library to use our libc, libstdc++ and others
  patchPhase =
    let
      rpath = lib.makeLibraryPath [
        stdenv.cc.libc
        stdenv.cc.cc.lib
      ];
    in
    ''
      chmod -R +w lib
      patchelf --set-rpath "${rpath}:$out/lib" lib/libtensorflow.so
      patchelf --set-rpath "${rpath}" lib/libtensorflow_framework.so
    '';

  buildPhase = ''
    # Write pkg-config file.
    mkdir lib/pkgconfig
    cat > lib/pkgconfig/tensorflow.pc << EOF
    Name: TensorFlow
    Version: ${version}
    Description: Library for computation using data flow graphs for scalable machine learning
    Requires:
    Libs: -L$out/lib -ltensorflow
    Cflags: -I$out/include/tensorflow
    EOF
  '';

  installPhase = ''
    mkdir -p $out
    cp -r LICENSE THIRD_PARTY_TF_C_LICENSES lib include $out
  '';

  meta = with lib; {
    homepage = "https://dl.photoprism.app/tensorflow/";
    description = "Libtensorflow version for usage with photoprism backend";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ benesim ];
  };
}
