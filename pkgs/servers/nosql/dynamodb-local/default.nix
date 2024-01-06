{ fetchzip
, jdk_headless
, jre_minimal
, lib
, makeWrapper
, stdenv
}:

let
  name = "dynamodb-local";

  release = "2024-01-04";
  version = "v2.x";

  jre = jre_minimal.override {
    modules = [
      "java.logging"
      "java.xml"
      "java.desktop"
      "java.management"
    ];
    jdk = jdk_headless;
  };
in
stdenv.mkDerivation {
  inherit name;

  version = ''${version}-${release}'';

  src = fetchzip {
    url = "https://d1ni2b6xgvw0s0.cloudfront.net/${version}/dynamodb_local_${release}.zip";
    hash = "sha256-Tpqbm7NeBrhptPeaegZFj+5WnUGTxw0ul5/Cv+QL6+c=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/
    install -D $src -d $out

    makeWrapper ${jre}/bin/java $out/bin/dynamodb-local \
      --add-flags "-Djava.library.path=$out/DynamoDBLocal_lib" \
      --add-flags "-jar $out/DynamoDBLocal.jar" \
      --add-flags "-inMemory"
  '';

  meta = with lib; {
    description = ''A local development version of Amazon DynamoDB (${release})'';
    homepage = "https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html";
    license = {
      fullName = "Amazon DynamoDB Local License Agreement";
      url = "https://aws.amazon.com/dynamodb/dynamodblocallicense/";
      free = false;
    };
    platforms = platforms.unix;
    maintainers = with maintainers; [ martinjlowm ];
  };
}
