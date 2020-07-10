{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "v${version}";
    sha256 = "1df6m1jjv8la6qcz3c5a6pw0jk81f1khx3d9q17d6v3ihrki8krk";
  };

  buildInputs = [ olm ];

  vendorSha256 = "1mgjfs9q3id36qb012l652ljcrvjaryjf6n4ry57k09gixla8wx9";

  overrideModAttrs = _: {
    postBuild = ''
      rm -r vendor/github.com/chai2010/webp
      cp -r --reflink=auto ${fetchFromGitHub {
        owner = "chai2010";
        repo = "webp";
        rev = "3da79ec3d682694d42bfd211db18fc1343c07cd7";
        sha256 = "0gh3g52vz8na153mjmxkl80g3dvrcjw77xpjs1c02vagpj9jyw46";
      }} vendor/github.com/chai2010/webp
    '';
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
