{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-06-01";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "f1b50a22f3c3d54dfb7df12bb607dee8638259d6";
    sha256 = "1fy8wqjrjnlv60xj7i6dflkw9kx3i7c7mwgqjjkg6afmmhmwr559";
  };

  buildInputs = [ olm ];

  vendorSha256 = "01psqvxkf13had7gkg1cbzf2flac4a6ivlb7vfzw7s50vhwkb95d";

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
