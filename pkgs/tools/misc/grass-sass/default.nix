{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "grass";
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-TRBbRKNr+/12dk8z7NAxAj/s+cGEQddXXuY2xmguLD8=";
  };

  cargoHash = "sha256-Kr/zTtZWAR0ZinhrlimoEtRMT+BrlO0MvhEJVlheXeM=";

  # tests require rust nightly
  doCheck = false;

  meta = with lib; {
    description = "A Sass compiler written purely in Rust";
    homepage = "https://github.com/connorskees/grass";
    changelog = "https://github.com/connorskees/grass/blob/master/CHANGELOG.md#${replaceStrings [ "." ] [ "" ] version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
