{
  openapi-generator-cli,
  fetchurl,
  runCommand,
}:

runCommand "openapi-generator-cli-test"
  {
    nativeBuildInputs = [ openapi-generator-cli ];
    petstore = fetchurl {
      url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/14c0908becbccd78252be49bd92be8c53cd2b9e3/examples/v3.0/petstore.yaml";
      hash = "sha256-q2D1naR41KwxLNn6vMbL0G+Pl1q4oaDCApsqQfZf7dU=";
    };
    config = builtins.toJSON {
      elmVersion = "0.19";
      elmPrefixCustomTypeVariants = false;
    };
    passAsFile = [ "config" ];
  }
  ''
    openapi-generator-cli generate \
      --input-spec $petstore \
      --enable-post-process-file \
      --generator-name elm \
      --config "$config" \
      --additional-properties elmEnableCustomBasePaths=true \
      --output "$out" \
      ;
    find $out
    echo >&2 'Looking for some keywords'
    set -x
    grep 'module Api.Request.Pets' $out/src/Api/Request/Pets.elm
    grep 'createPets' $out/src/Api/Request/Pets.elm
    grep '"limit"' $out/src/Api/Request/Pets.elm
    set +x
    echo "Looks OK!"
  ''
