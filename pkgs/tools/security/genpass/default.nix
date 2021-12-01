{ lib, stdenv
, fetchgit
, rustPlatform
, CoreFoundation
, libiconv
, Security
}:
rustPlatform.buildRustPackage rec {
  pname = "genpass";
  version = "0.4.12";

  src = fetchgit {
    url = "https://git.sr.ht/~cyplo/genpass";
    rev = "v${version}";
    sha256 = "154kprbqc59f06ciz60il4ax299zapwa0hz8vjn25rl4gr5gzn4l";
  };

  cargoSha256 = "1b9jqkg11d0ih46km063inqqjwfy1nrwb2xb3dagg3hi8hahpqpb";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation libiconv Security ];

  meta = with lib; {
    description = "A simple yet robust commandline random password generator";
    homepage = "https://sr.ht/~cyplo/genpass/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ cyplo ];
  };
}
