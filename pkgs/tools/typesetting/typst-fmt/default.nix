{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "typst-fmt";
  version = "unstable-2023-04-16";

  src = fetchFromGitHub {
    owner = "astrale-sharp";
    repo = pname;
    rev = "9ed1fd1656f8e776b6c8d9d326c488f5ba1091eb";
    hash = "sha256-yHR13n5yx5Yl2atteGQq+qqz21zsy37ZJfGllbvSZcQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-0.2.0" = "sha256-+YHyxZTzMG9zpzLV9NgJsMtrXG+/ymPQo5b26HDYJaQ=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  checkFlags = [
    # test_eof is ignored upstream
    "--skip=rules::tests_typst_format::test_eof"
  ];

  meta = with lib; {
    description = "A formatter for the Typst language";
    homepage = "https://github.com/astrale-sharp/typst-fmt";
    license = licenses.mit;
    maintainers = with maintainers; [ geri1701 ];
  };
}
