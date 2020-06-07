{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "v${version}";
    sha256 = "0cjgyn311zvpdsagyndkw89bvdrcli5kqznss8dsh05wrllxp3x4";
  };

  buildInputs = [ olm ];

  vendorSha256 = "0980p9x62iav6j1w36w2i8pqyv6amnx4ngrgylq2vkjlcgihl2i8";

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
