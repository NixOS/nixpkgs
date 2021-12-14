{ lib
, fetchFromGitHub
, makeWrapper
, rustPlatform
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "wluma";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    rev = version;
    sha256 = "sha256-fqBEJS+SQoPNNEw6jyoiZjq/chY73bQ+cM21F8RdNPE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/wluma \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ vulkan-loader ]}"
  '';

  cargoSha256 = "sha256-dZBA6VeJRHmqpazRwjLP1kYcYYN5LCFWkIaXqp4/RkQ=";

  meta = with lib; {
    description = "Automatic brightness adjustment based on screen contents and ALS";
    homepage = "https://github.com/maximbaz/wluma";
    license = licenses.isc;
    maintainers = with maintainers; [ yevhenshymotiuk ];
    platforms = platforms.linux;
  };
}
