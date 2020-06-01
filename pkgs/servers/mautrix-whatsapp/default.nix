{ stdenv, buildGoModule, fetchFromGitHub, olm }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-05-29";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "7947ba616ca1b776883ca7db9cab8de9ee8d9ee6";
    sha256 = "10rkkjnbppv9gi67hknijh8ib841qyy16grdw29gz3ips6qs8zq7";
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
