{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "mautrix-whatsapp-unstable";
  version = "2020-03-26";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = "mautrix-whatsapp";
    rev = "3a9642386cdff8293657c8409da4bffd674184bf";
    sha256 = "183ghrm83vlnalmlxq69xinvkylnxwmz41wwm5s4035arizkjh1b";
  };

  modSha256 = "01xwq0h3i8ai0294v8jdagksas48866lxcnkn4slwp3rnzv6cmbp";

  meta = with stdenv.lib; {
    homepage = https://github.com/tulir/mautrix-whatsapp;
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ vskilet ma27 ];
  };
}
