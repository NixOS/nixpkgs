{ lib, buildPythonPackage, fetchFromGitHub, rustPlatform
, python
, llvm_11
, libffi
, zlib
, ncurses
, libxml2
, pkg-config
}:

let
  pname = "wasmer-compiler-cranelift";
  # setup.py for wasmer-compiler-cranelift wasn't added until after tag
  version = "unstable-2021-05-12";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wasmer-python";
    rev = "c2ef240e0355b7ab3b5f3cf5ae0954cda79304a5";
    sha256 = "1yq45ggpqjq23pvf3fz3g7wr2maw8ls2mr2x7aq6rrrdp4029ps2";
  };

  meta = with lib; {
    description = "Cranelift compiler for the `wasmer` package";
    homepage = "https://github.com/wasmerio/wasmer-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };

  nativeExtensions = rustPlatform.buildRustPackage rec {
    inherit pname version src meta;

    cargoSha256 = "0538zqjg8c1ahahjn92sqnsxixa6hi5sj1rrvw864yxiidddzxpd";

    nativeBuildInputs = [ python pkg-config llvm_11 ];

    buildInputs = [ zlib ncurses libffi libxml2 python ];

    NIX_LDFLAGS = "-lpython3 ";

    # tests are unable to link to python
    doCheck = false;
  };

in buildPythonPackage rec {
  inherit pname version src meta;

  preConfigure = ''
    cd packages/any-compiler-cranelift/
  '';

  # the setup.py just installs a __init__.py which throws an error, replace with native extensions
  postInstall = ''
    ln -fs -t $out/${python.sitePackages} ${nativeExtensions}/lib/*
  '';

  doCheck = false;

  pythonImportsCheck = [ "libwasmer_compiler_cranelift" ];
}

